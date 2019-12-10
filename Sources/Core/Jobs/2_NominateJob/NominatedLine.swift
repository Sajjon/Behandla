//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

/// A line nominated for the short list of resulting BIP39 words (from lines).
struct NominatedLine: LineFromCorpus, Hashable {
    let wordForm: WordForm
    let partOfSpeechTag: PartOfSpeech
    let lemgrams: Lemgrams
    let isCompoundWord: Bool
    let numberOfOccurencesInCorpus: Int
    let relativeFrequencyPerOneMillion: Int

    // MARK: Meta properties
    let indexOfLineInCorpus: Int
}
