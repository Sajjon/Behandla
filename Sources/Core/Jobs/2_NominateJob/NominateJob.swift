//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

struct NominateJob: CacheableJob {
    let runContext: RunContext
}

// MARK: CacheableJob
extension NominateJob {
    typealias Input = ParsedLines
    typealias Output = NominatedLines

    func newWork(input parsedLines: Input) throws -> Output {
        var nominatedLines = [NominatedLine]()

        let matcher: IncludeIf<ParsedLine> = [
            .wordHasGoodLength,
            .partOfSpeechIsWhitelisted,
        ]

        for parsedLine in parsedLines {
            guard matcher.checkIfLineShouldBeIncluded(line: parsedLine) else {
                continue
            }
            let nominatedLine = NominatedLine(line: parsedLine)
            nominatedLines.append(nominatedLine)
        }
        return NominatedLines(nominatedLines)
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

    static var wordHasGoodLength: Self {
        Self(isCompound: true) { Self.wordIsNotTooShort.isLineGood($0) && Self.wordIsNotTooLong.isLineGood($0) }
    }

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
