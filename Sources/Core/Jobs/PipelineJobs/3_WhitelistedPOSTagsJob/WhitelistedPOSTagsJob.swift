//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-11.
//

import Foundation

struct WhitelistedPOSTagsJob: RulesJob {
    typealias Input = WordLengthLines
    typealias Output = WhitelistedPOSTagLines

    let runContext: RunContext

    let rulesMatcher: RulesMatcher = [
        .partOfSpeechIsWhitelisted,
    ]

    func output(fromInputLine inputLine: WordLengthLine) -> WhitelistedPOSTagLine {
        WhitelistedPOSTagLine(line: inputLine)
    }
}

// MARK: IncludeIf Rules
private extension IncludeIf.Rule {
    static var partOfSpeechIsWhitelisted: Self {
        Self {
            Set<PartOfSpeech>.whitelisted.contains($0.partOfSpeechTag)
        }
    }
}

// MARK: Whitelist POS
extension Set where Element == PartOfSpeech {
    static var whitelisted: Set<PartOfSpeech> {
        return Set([
            .noun,
            .adjective,
            .verb,
            .adverb
        ])
    }
}
