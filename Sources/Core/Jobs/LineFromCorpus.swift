//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

protocol LineFromCorpus: CustomStringConvertible, CustomDebugStringConvertible, Codable {
    /// The word, on lowercased form
    var wordForm: WordForm { get }

    /// Part of speech tag, only first major tag, .e.g from line `han    PN.UTR.SIN.DEF.SUB`, we only save `PN`
    var partOfSpeechTag: PartOfSpeech { get }

    /// Base form(s) of word
    var lemgrams: Lemgrams { get }

    /// Whether this is a compound word or not, an example of a compound word is 🇸🇪_"stämband"_,
    /// consisting of the word _"stäm"_ and the word _"band"_.
    var isCompoundWord: Bool { get }

    /// The total frequency, the number of occurences of the word form in the corpus.
    var numberOfOccurencesInCorpus: Int { get }

    /// The relative frequency of the word form in the corpus per 1 million words.
    var relativeFrequencyPerOneMillion: Int { get }

    // MARK: Meta properties

    /// The index of this parsed line in the corpus
    var indexOfLineInCorpus: Int { get }

    init(
        wordForm: WordForm,
        partOfSpeechTag: PartOfSpeech,
        lemgrams: Lemgrams,
        isCompoundWord: Bool,
        numberOfOccurencesInCorpus: Int,
        relativeFrequencyPerOneMillion: Int,
        indexOfLineInCorpus: Int
    )
}

extension LineFromCorpus {
    init(line: LineFromCorpus) {
        self.init(
            wordForm: line.wordForm,
            partOfSpeechTag: line.partOfSpeechTag,
            lemgrams: line.lemgrams,
            isCompoundWord: line.isCompoundWord,
            numberOfOccurencesInCorpus: line.numberOfOccurencesInCorpus,
            relativeFrequencyPerOneMillion: line.relativeFrequencyPerOneMillion,
            indexOfLineInCorpus: line.indexOfLineInCorpus
        )
    }
}

enum LineCodingKeys: String, CodingKey {
    case wordForm = "w"
    case partOfSpeechTag = "p"
    case lemgrams = "l"
    case isCompoundWord = "c"
    case numberOfOccurencesInCorpus = "n"
    case relativeFrequencyPerOneMillion = "r"
    case indexOfLineInCorpus = "i"
}

// MARK: Codable
extension LineFromCorpus {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: LineCodingKeys.self)
        self.init(
            wordForm: try container.decode(WordForm.self, forKey: .wordForm),
            partOfSpeechTag: try container.decode(PartOfSpeech.self, forKey: .partOfSpeechTag),
            lemgrams: try container.decode(Lemgrams.self, forKey: .lemgrams),
            isCompoundWord: try container.decode(Bool.self, forKey: .isCompoundWord),
            numberOfOccurencesInCorpus: try container.decode(Int.self, forKey: .numberOfOccurencesInCorpus),
            relativeFrequencyPerOneMillion: try container.decode(Int.self, forKey: .relativeFrequencyPerOneMillion),
            indexOfLineInCorpus: try container.decode(Int.self, forKey: .indexOfLineInCorpus)
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: LineCodingKeys.self)
        try container.encode(wordForm, forKey: .wordForm)
        try container.encode(partOfSpeechTag, forKey: .partOfSpeechTag)
        try container.encode(lemgrams, forKey: .lemgrams)
        try container.encode(isCompoundWord, forKey: .isCompoundWord)
        try container.encode(numberOfOccurencesInCorpus, forKey: .numberOfOccurencesInCorpus)
        try container.encode(relativeFrequencyPerOneMillion, forKey: .relativeFrequencyPerOneMillion)
        try container.encode(indexOfLineInCorpus, forKey: .indexOfLineInCorpus)
    }
}

extension LineFromCorpus {
    var description: String {
        "\(wordForm) (\(partOfSpeechTag))"
    }

    var debugDescription: String {
        "\(wordForm), pos: \(partOfSpeechTag), lemgrams: \(lemgrams), index: \(indexOfLineInCorpus)"
    }
}
