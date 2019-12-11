//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-11.
//

import Foundation

protocol LineFromCorpusComponents: LineFromCorpusConvertible {

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

// MARK: Decodable
extension LineFromCorpusComponents {
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
}

//// MARK: `LineFromCorpusComponents` => Default `LineFromCorpusFromLine`
//extension LineFromCorpusComponents {
//    init(anyLine line: LineFromCorpusConvertible) {
//        self.init(
//            wordForm: line.wordForm,
//            partOfSpeechTag: line.partOfSpeechTag,
//            lemgrams: line.lemgrams,
//            isCompoundWord: line.isCompoundWord,
//            numberOfOccurencesInCorpus: line.numberOfOccurencesInCorpus,
//            relativeFrequencyPerOneMillion: line.relativeFrequencyPerOneMillion,
//            indexOfLineInCorpus: line.indexOfLineInCorpus
//        )
//    }
//}
