//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

struct WordLengthJob: RulesJob {
    typealias Input = ParsedLines
    typealias Output = WordLengthLines

    let runContext: RunContext

    let rulesMatcher: RulesMatcher = [
        .wordIsNotTooShort,
        .wordIsNotTooLong,
    ]

    func output(fromInputLine inputLine: ParsedLine) -> WordLengthLine {
        WordLengthLine(line: inputLine)
    }
}

// MARK: IncludeIf Rules
private extension IncludeIf.Rule {
    static var wordIsNotTooShort: Self {
        Self { $0.wordLength >= BIP39.minimumWordLength }
    }

    static var wordIsNotTooLong: Self {
        Self { $0.wordLength <= BIP39.maximumWordLength }
    }
}
