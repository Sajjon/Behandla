# What is this?
This is #PureSwift code for construction of a [BIP39](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki) compatible list of common Swedish words. For analysis I've used some Python too.

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

