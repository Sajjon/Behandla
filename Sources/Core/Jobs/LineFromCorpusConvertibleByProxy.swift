//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-11.
//

import Foundation

protocol LineFromCorpusConvertibleByProxy: LineFromCorpusConvertible {
    associatedtype Line: LineFromCorpusConvertible
    var line: Line { get }
}

extension LineFromCorpusConvertibleByProxy {
    var wordForm: WordForm { line.wordForm }
    var partOfSpeechTag: PartOfSpeech { line.partOfSpeechTag }
    var lemgrams: Lemgrams { line.lemgrams }
    var isCompoundWord: Bool { line.isCompoundWord }
    var numberOfOccurencesInCorpus: Int { line.numberOfOccurencesInCorpus }
    var relativeFrequencyPerOneMillion: Int { line.relativeFrequencyPerOneMillion }
    var indexOfLineInCorpus: Int { line.indexOfLineInCorpus }
}
