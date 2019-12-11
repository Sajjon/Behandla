//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-11.
//

import Foundation

protocol LineFromCorpusConvertible: CustomStringConvertible, Codable {
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
}

extension LineFromCorpusConvertible {
    var description: String {
        "\(wordForm) (\(partOfSpeechTag))"
    }

//    var debugDescription: String {
//        "\(wordForm), pos: \(partOfSpeechTag), lemgrams: \(lemgrams), index: \(indexOfLineInCorpus)"
//    }
}

extension LineFromCorpusConvertible {
    var wordLength: Int { wordForm.lowercasedWord.count }
}

// MARK: Encodable
extension LineFromCorpusConvertible {
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
