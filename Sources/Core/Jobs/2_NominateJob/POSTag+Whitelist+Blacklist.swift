//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-07.
//

import Foundation

public extension Set where Element == PartOfSpeech {
    static var blacklisted: Set<PartOfSpeech> {
        return Set([
            .foreignWord
        ])
    }

    static var whitelisted: Set<PartOfSpeech> {
        return Set([
            .noun,
            .adjective,
            .verb,
            .adverb
        ])
    }
}
