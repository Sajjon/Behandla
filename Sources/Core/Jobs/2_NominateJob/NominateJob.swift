//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

struct NominateJob: CacheableJob {
    let shouldCache: Bool
}

// MARK: CacheableJob
extension NominateJob {
    typealias Input = ParsedLines
    typealias Output = NominatedLines

    func newWork(input: Input) throws -> Output {
        var nominatedLines = OrderedSet<NominatedLine>()

        let rules: Rules = [
            .wordIsTooLong,
            .wordIsTooShort
        ]

        for parsedLine in input.parsedLines {
            if rules.excludes(line: parsedLine) {
                continue
            }
            let nominatedLine = NominatedLine(parsedLine: parsedLine)
            nominatedLines.append(nominatedLine)
        }
        return NominatedLines(nominatedLines: nominatedLines)
    }
}

struct Rules: ExpressibleByArrayLiteral {
    let rules: [ExcludeIf]
    init(rules: [ExcludeIf]) {
        self.rules = rules
    }
    init(arrayLiteral rules: ExcludeIf...) {
        self.init(rules: rules)
    }
}


extension Rules {
    func excludes(line: ParsedLine) -> Bool {
        for rule in rules {
            guard !rule.excludes(line: line) else { return false }
        }
        return true
    }
}

extension Rules {
    struct ExcludeIf {
        typealias ExcludesLineIf = (ParsedLine) -> Bool

        let name: String
        private let excludeLineIf: ExcludesLineIf

        init(name: String = #function, excludeLineIf: @escaping ExcludesLineIf) {
            self.name = name
            self.excludeLineIf = excludeLineIf
        }
    }
}

extension Rules.ExcludeIf {
    func excludes(line: ParsedLine) -> Bool {
        let excluded = excludeLineIf(line)
//        if excluded {
//            print("👎 \(name.toHumanReadable()): <\(line)>")
//        }
        return excluded
    }
}

extension Rules.ExcludeIf {
    static var wordIsTooShort: Self {
        Self { $0.lengthOfWordForm < BIP39.minimumWordLength }
    }

    static var wordIsTooLong: Self {
        Self { $0.lengthOfWordForm > 11 }
    }
}

private extension ParsedLine {
    var lengthOfWordForm: Int { wordForm.lowercasedWord.count }
}

private extension String {

    func toHumanReadable() -> String {
        replaceCamelCaseWith(replacement: " ")
    }

    func replaceCamelCaseWith(replacement: String) -> String {
        let acronymPattern = "([A-Z]+)([A-Z][a-z]|[0-9])"
        let normalPattern = "([a-z0-9])([A-Z])"

        func processCamalCaseRegex(pattern: String, in string: String) -> String? {
            let regex = try? NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(location: 0, length: count)
            return regex?.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: "$1\(replacement)$2")
        }

        guard
            let first = processCamalCaseRegex(pattern: acronymPattern, in: self)
            else {
                return self.lowercased()
        }
        guard let second = processCamalCaseRegex(pattern: normalPattern, in: first) else {
            return first.lowercased()
        }
        return second.lowercased()
    }


}
