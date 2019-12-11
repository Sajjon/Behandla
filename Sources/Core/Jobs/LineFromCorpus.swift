//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

protocol LineFromCorpus: LineFromCorpusConvertible {

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
    init(line: LineFromCorpusConvertible) {
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
