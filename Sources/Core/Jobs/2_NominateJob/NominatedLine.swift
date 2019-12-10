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

    init(word: String, partOfSpeechTag: PartOfSpeech) {
        self.word = word
        self.partOfSpeechTag = partOfSpeechTag
    }
}

public extension NominatedLine {
    var description: String {
        "\(word) (\(partOfSpeechTag))"
    }
}

extension NominatedLine {
    init(parsedLine: ParsedLine) {
        self.init(
            word: parsedLine.wordForm.lowercasedWord,
            partOfSpeechTag: parsedLine.partOfSpeechTag
        )
    }
}
