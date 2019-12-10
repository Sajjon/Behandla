# What is this?
This is #PureSwift code for construction of a [BIP39](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki) compatible list of common Swedish 🇸🇪 words. For analysis I've used some Python too.

# Meta Corpus
I have not used a "raw" corpus, but rather a parsed version which contains metadata regarding frequency, which saves a lot of time. So even though this is not a "raw" corpus, but rather a semi processed one, I will refer to it as the "corpus".

I've used Språkbankens ["Korpusstatistik"](https://spraakbanken.gu.se/swe/forskning/infrastruktur/korp/korpusstatistik). Here we can find many documents, but I've used the aggregated file (_"Samtliga i en fil"_), which is a 4.9 gb document you can download for yourself [here](https://svn.spraakdata.gu.se/sb-arkiv/pub/frekvens/stats_all.txt). The file was as of today (2019-12-07) last updated 2019-05-16. It contains 957,472,046 sentences and 13,310,488,661 _tokens_.

Information about the format of the statistical document can be found [here](https://spraakbanken.gu.se/eng/info)


## Format
Each line in the corpus contains six columns on a tab-separated format:

```
är  VB.PRS.AKT  |vara..vb.1|    -   316581  13026.365036
```

The columns contain this information:
1. Word form (🇸🇪: _ordform_)
2. Part of speech (🇸🇪:_ordklass_), legend [here](https://spraakbanken.gu.se/korp/markup/msdtags.html))
3. Base form (🇸🇪: _lemgram -vilka refererar till en viss grundform och böjningstabell)
4. `+` or `-` which indicates whether a compound analysis was possible or not. E.g. (🇸🇪: _"stämband"_, is a compound word consisting of _"stäm"_ and _"band"_)
5. Raw frequencey (total number of occurences)
6. Relative frequency (number of occurences per 1 million words)

(More about _"lemgram"_, [from explaination here](https://spraakbanken.gu.se/swe/forskning/infrastruktur/korp/anvandarhandledning) -  _ett lemgram är ett ords eller ett flerordsuttrycks samtliga böjningsformer, och gör det möjligt att i en och samma sökning söka efter både "katt", "katter", "katterna" och så vidare._)


# Methodology

## Which Part of Speech distribution to use?
In file [analysis_of_english.py](analysis_of_english.py) I've written a small script analyzing the part of speech (POS) tags used in the [English BIP39 list](https://github.com/bitcoin/bips/blob/master/bip-0039/english.txt), using awesome Python tool [`NLTK`](https://www.nltk.org/book/ch05.html)(Natural Language Toolkit).

You can view the result along with the POS distribution of the Swedish word list (the result of this program) in this [Google Sheet](https://docs.google.com/spreadsheets/d/1Hhn9MdM4-r1GyzAE_QYFeLwu4zZbzZbJmhQe_C07x10/edit?usp=sharing)

The result is 62% Noun (`NN`), 23% Adjective (`JJ`), 9% Verb (`VB`), 3% Adverb (`RB`), 2% Preposition (`IN`).

## Algorithm
The algorithm used is heavily dependent on the source data, i.e. the format of each line in the corpus.

### Read lines

In this step we read `L` number of lines of the source corpus. The result of this program is a BIP39 compatible wordlist which contains 2048 (`2¹¹`) words. 

The goal of this step is to convert the source corpus into Swift `Line` models which we can write to a JSON file to allow faster execution of the program next time. For the next run of the program we can thus skip to step 2.

We are going to reject *a lot* of lines in the source corpus, because it contains delimitors. It also contains words being to short (less than 3 characters, e.g. common Swedish words 🇸🇪: _"en"_ (🇬🇧:_"one"_), and prepositions 🇸🇪: _"i"_ (🇬🇧: _"in"_).

The model of the line is thus:
```swift
struct ReadLine {

    // Read verbatim from corpus
    let wordForm: String
    let partOfSpeechTag: PartOfSpeechTag
    let baseForm: String
    let compoundWord: Bool
    let totalNumberOfOccurences: Int
    let relativeNumberOfOccurences: Double
    
    // Appended by this program
    let positionInCorpus: Int
    let indexInListOfIncludedParsedLines: Int
}
```
We read the corpus until we have created a list of `L` lines. This step should not so much logic, but it is uncessary to save lines which we know we will reject, e.g. because the word is too short, or because it is a delimitor.

But if we are going to reject the line because the "word" is too short, what do we mean by "word", the read word (part one of the line) Or the base word of the line (part three of the line)?

On line #252 in the corpus (which is really early) we find this line:

`sa VB.PRT.AKT  |säga..vb.1|    -   4857774 364.958352`

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

[Here is a good online tool to check meanings of Swedish words](https://spraakbanken.gu.se/ws/saldo-ws/fl/html/banan)

## Homophones 👎
Homophones are words with different spelling, but same pronouncation. E.g 🇸🇪: _"egg"_ and 🇸🇪: _"ägg"_  (🇬🇧: _"edge"_ (🔪) and _"egg"_(🥚) respectively). My theory is that this makes it harder to remember (since spelling matters). 

Even though it seems likely that we do not want any homophones in the list, it is not so easy to identify them automatically. Below follow some algorthms.

### Algorithms
https://github.com/ticki/eudex

### Papers about Swedish phonetic algorithms
https://www.nada.kth.se/utbildning/grukth/exjobb/rapportlistor/2011/rapporter11/spaedtke_johan_11076.pdf
