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

    func newWork(input: Input) throws -> Output {
        var nominatedLines = OrderedSet<NominatedLine>()

        let matcher: IncludeIf = [
            .wordHasGoodLength,
            .partOfSpeechIsWhitelisted,
        ]

        for parsedLine in input.parsedLines {
            guard matcher.checkIfLineShouldBeIncluded(line: parsedLine) else {
                continue
            }
            let nominatedLine = NominatedLine(parsedLine: parsedLine)
            nominatedLines.append(nominatedLine)
        }
        return NominatedLines(lines: nominatedLines)
    }
}

struct IncludeIf: ExpressibleByArrayLiteral {
    let rules: [Rule]
    init(rules: [Rule]) {
        self.rules = rules
    }
    init(arrayLiteral rules: Rule...) {
        self.init(rules: rules)
    }
}


extension IncludeIf {
    func checkIfLineShouldBeIncluded(line: ParsedLine) -> Bool {
        rules.allSatisfy { $0.isLineGood(line) }
    }
}

extension IncludeIf {
    struct Rule {
        typealias IncludeLineIf = (ParsedLine) -> Bool

        let nameOfRule: String
        private let includeLineIf: IncludeLineIf
        let isCompound: Bool
        init(name: String = #function, isCompound: Bool = false, includeLineIf: @escaping IncludeLineIf) {
            self.nameOfRule = name
            self.isCompound = isCompound
            self.includeLineIf = includeLineIf
        }
    }
}

extension IncludeIf.Rule {
    func isLineGood(_ line: ParsedLine) -> Bool {
        let included = includeLineIf(line)
        if !included && !isCompound {
//            print("👎 \(nameOfRule): <\(line)>")
        }
        return included
    }
}

extension IncludeIf.Rule {
    static var wordIsNotTooShort: Self {
        Self { $0.lengthOfWordForm >= BIP39.minimumWordLength }
    }

    static var wordIsNotTooLong: Self {
        Self { $0.lengthOfWordForm <= 11 }
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

private extension ParsedLine {
    var lengthOfWordForm: Int { wordForm.lowercasedWord.count }
}

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
