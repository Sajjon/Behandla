//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-11.
//

import Foundation

enum LineCodingKeys: String, CodingKey {
    case wordForm = "w"
    case partOfSpeechTag = "p"
    case lemgrams = "l"
    case isCompoundWord = "c"
    case numberOfOccurencesInCorpus = "n"
    case relativeFrequencyPerOneMillion = "r"
    case indexOfLineInCorpus = "i"
}
