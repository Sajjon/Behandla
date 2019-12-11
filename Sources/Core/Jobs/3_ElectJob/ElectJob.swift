//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation
import Rainbow

/// Based on nominated lines we perform computation heavy logic on the words, such as finding homonyms. Ranking lines based on a balance between frequency and homonym count according
/// to some function
struct ElectJob: CacheableJob {
    let runContext: RunContext
}


// MARK: CacheableJob
extension ElectJob {
    typealias Input = NominatedLines
    typealias Output = ElectedLines

    func newWork(input nominatedLines: Input) throws -> Output {
        let maxLineCount = 35_000
        guard nominatedLines.count < maxLineCount else {
            fatalError("This job is extremely slow, should not be run with more than #\(maxLineCount) lines, but got: #\(nominatedLines.count) lines")
        }

        let homonymsBuilder = HomonymsBuilder()
        for line in nominatedLines {
            homonymsBuilder.add(line: line)
        }
        let homonyms = homonymsBuilder.build()
        print(homonyms)
        let homonymsByWord = homonyms.forWord

        var rankedLinesUnsorted = [(line: NominatedLine, rank: Rank, homonym: Homonym?)]()
        for line in nominatedLines {
            let homonym = homonymsByWord[line.wordForm]
            let rank = rankLine(line, homonym: homonym)
            rankedLinesUnsorted.append((line: line, rank: rank, homonym: homonym))
        }

        let rankedLines = rankedLinesUnsorted.sorted(by: { $0.rank > $1.rank })

        let electedLines = rankedLines.prefix(100).map { ElectedLine(line: $0.line, rank: $0.rank, homonym: $0.homonym) }

        let result = ElectedLines(electedLines)
        printRankFormula()
        print(result)
        return result
    }

    func validateCached(_ cached: ElectedLines) throws {
        struct NotDone: Swift.Error {}
        throw NotDone()
    }
}


// MARK: - Private
private let ℏ: Double = 0.6
private extension ElectJob {

    ///
    /// Rank is based on number of occurences in corpus (`#occ`) and `#meanings` (homonyms)
    /// and a factor `ℏ`.
    ///
    ///     `#occ * (1 + ℏ * #meanings)`
    ///
    func rankLine(_ line: LineFromCorpus, homonym: Homonym?) -> Rank {
        let numberOfOccurencesInCorpus = Double(line.numberOfOccurencesInCorpus)
        var points = numberOfOccurencesInCorpus
        if let homonym = homonym {
            let meanings = Double(homonym.count)
            points = numberOfOccurencesInCorpus * (1 + ℏ * meanings)
        }
        return Rank(points: points)
    }

    func printRankFormula() {
        print("Ranked lines according to formula:")
        print(
            [
                "occurences".italic.red,
                "+",
                "*",
                "(",
                "1".bold,
                "+",
                "ℏ=\(ℏ)".bold.magenta,
                "*",
                "meanings".italic.red,
                ")"
                ].joined(separator: " ")
        )
        print("\n")
    }
}

// MARK: Rank
struct Rank: Comparable, Codable, Hashable, CustomStringConvertible {
    let points: Double
}

// MARK: Comparable
extension Rank {
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.points < rhs.points
    }
}

// MARK: Comparable
extension Rank {
    var description: String {
        Int(points).description
    }
}

extension CustomStringConvertible {
    func pad(minLength: Int = BIP39.maximumWordLength + 1) -> String {
        var selfString = self.description
        while selfString.count < minLength {
            selfString += " "
        }
        return selfString
    }
}

// MARK: IncludeIf Rules
//private extension IncludeIf.Rule {
//    static var wordIsNotTooShort: Self {
//        Self { $0.wordLength >= BIP39.wordLength }
//    }
//}

