//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

/// A line that has advanced from the nominated short list of lines, awaiting confirmation of becomming part of the 2048 BIP39 words.
struct ElectedLine: LineFromCorpus, Hashable {
    let wordForm: WordForm
    let partOfSpeechTag: PartOfSpeech
    let lemgrams: Lemgrams
    let isCompoundWord: Bool
    let numberOfOccurencesInCorpus: Int
    let relativeFrequencyPerOneMillion: Int

    // MARK: Meta properties
    let indexOfLineInCorpus: Int
}
