//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

/// A line nominated for the short list of resulting BIP39 words (from lines).
public struct NominatedLine: Hashable, Codable, CustomStringConvertible {
    let word: String
    let partOfSpeechTag: PartOfSpeech
}

public extension NominatedLine {
    var description: String {
        "\(word) (\(partOfSpeechTag))"
    }
}

extension NominatedLine {
    init(parsedLine: ParsedLine) {
        self.word = parsedLine.wordForm.lowercasedWord
        self.partOfSpeechTag = parsedLine.partOfSpeechTag
    }
}
