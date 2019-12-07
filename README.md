# What is this?
This is #PureSwift code for construction of a [BIP39](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki) compatible list of common Swedish 🇸🇪 words. For analysis I've used some Python too.

# Corpus
I've used the statistics document ([stats_PAROLE.txt](https://svn.spraakdata.gu.se/sb-arkiv/pub/frekvens/stats_PAROLE.txt)) of the [Parole Corpus](https://spraakbanken.gu.se/eng/resource/parole) containing around 19 million tokens.

## Format
Each line start with a word, and statistics and meta data about it, on a tab-separated format:
```
är  VB.PRS.AKT  |vara..vb.1|    -   316581  13026.365036
```

Explanation:
* `är` is the **word** (English transation of the word: _is_ / _am_ / _are_)  
* `VB.PRS.AKT` is the **part of speech (POS) tag**, meaning _verb presens aktiv_ (English transation of the POS tag: _Verb present tense active_). 
* `|vara..vb.1|` gives information about the base form of the word, here _vara_ means _to be_. 
* `316581` is the number of occurences in the corpus. 
* `13026.365036` I don't know what the last float number is, if you know, please tell me :).  

# Methodology

## Which Part of Speech distribution to use?
In file [analysis_of_english.py](analysis_of_english.py) I've written a small script analyzing the part of speech (POS) tags used in the [English BIP39 list](https://github.com/bitcoin/bips/blob/master/bip-0039/english.txt), using awesome Python tool [`NLTK`](https://www.nltk.org/book/ch05.html)(Natural Language Toolkit).

You can view the result along with the POS distribution of the Swedish word list (the result of this program) in this [Google Sheet](https://docs.google.com/spreadsheets/d/1Hhn9MdM4-r1GyzAE_QYFeLwu4zZbzZbJmhQe_C07x10/edit?usp=sharing)

The result is 62% Noun (`NN`), 23% Adjective (`JJ`), 9% Verb (`VB`), 3% Adverb (`RB`), 2% Preposition (`IN`).

## Algorithm
The algorithm used is heavily dependent on the source data, i.e. the format of each line in the corpus.

To recap, the lines contain this information (separated by tabs)

`WORD | POS | BASE_FORM | NUMBER_OF_OCCURENCES`

### Read lines

In this step we read `L` number of lines of the source corpus. The result of this program is a BIP39 compatible wordlist which contains 2048 (`2¹¹`) words. 

The goal of this step is to convert the source corpus into Swift `Line` models which we can write to a JSON file to allow faster execution of the program next time. For the next run of the program we can thus skip to step 2.

We are going to reject *a lot* of lines in the source corpus, because it contains delimitors. It also contains words being to short (less than 3 characters, e.g. common Swedish words 🇸🇪: _"en"_ (🇬🇧:_"one"_), and prepositions 🇸🇪: _"i"_ (🇬🇧: _"in"_).

The model of the line is thus:
```swift
struct ReadLine {

    // Read verbatim from corpus
    let word: String
    let partOfSpeechTag: PartOfSpeechTag
    let baseForm: String
    let numberOfOccurences: Int
    
    // Appended by this program
    let positionInCorpus: Int
    let indexInListOfIncludedParsedLines: Int
}
```
We read the corpus until we have created a list of `L` lines. This step should not so much logic, but it is uncessary to save lines which we know we will reject, e.g. because the word is too short, or because it is a delimitor.

But if we are going to reject the line because the "word" is too short, what do we mean by "word", the read word (part one of the line) Or the base word of the line (part three of the line)?

On line #119 in the corpus (which is really early, since around ~100 of these 119 lines are probably going to be rejected (because too short, or prepositions etc)) we find this line:

`sa    VB.PRT.AKT    |säga..vb.1|    -    16499    678.884698`

If we were to *just* look at the _word_ (first part) - 🇸🇪: _"sa"_ (🇬🇧: _"said"_), we would reject this line since it is less than threshold character count of 3, however, if we look at the base word, 🇸🇪: _"säga"_ (🇬🇧: _"to say"_), it is four characters long. Thus including this line we might get interesting data for the decision in relation to the base word. 

Apart from data parsed from corpus we add two properties, `positionInCorpus` and `indexInListOfIncludedParsedLines`.



# Decisions

(this section is a work in progress)

## Hononyms 👍
A hononym is a word with multiple meanings given the same spelling. E.g. 🇸🇪: _"fil"_ with that exact same spelling, it means multiple things: 🇬🇧: _"(computer) file"_, 🇬🇧: _"(traffic) lane"_, 🇬🇧: _"fermented milk"_ , 🇬🇧: _"rasp (tool)"_. 

Since the idea of BIP39 is that the words should be easy to remember and words with multiple meanings might be easier to get associations with and thus easier to remember, given that they are common enough.

My assumption/theory/idea is that a word at frequency index `i` with only one meaning, might not be as suitable as hononym at index `i + 𝚫` (later in the frequency list, i.e. not as common word). The question is where to draw the line. The relation between 𝚫 and #meanings.

### Homograph
A homograph is a word with the same spelling but different pronouncation, e.g. 🇸🇪: _"banan"_, which can mean 🇬🇧: _"the lane" or 🇬🇧: _"the banana"_. Since homographs are a subset of homonyms they are welcome. In fact a homonym being a homograph might be even better for creating different associations than a non-homographical homonym.


## Homophones 👎
Homophones are words with different spelling, but same pronouncation. E.g 🇸🇪: _"egg"_ and 🇸🇪: _"ägg"_  (🇬🇧: _"edge"_ (🔪) and _"egg"_(🥚) respectively). My theory is that this makes it harder to remember (since spelling matters). 

Even though it seems likely that we do not want any homophones in the list, it is not so easy to identify them automatically. Below follow some algorthms.

### Algorithms
https://github.com/ticki/eudex

### Papers about Swedish phonetic algorithms
https://www.nada.kth.se/utbildning/grukth/exjobb/rapportlistor/2011/rapporter11/spaedtke_johan_11076.pdf
