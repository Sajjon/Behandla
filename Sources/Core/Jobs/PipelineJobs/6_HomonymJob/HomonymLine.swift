//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

/// A line which has got identified homonyms.
struct HomonymLine: LineFromCorpusFromLineAndOther, Hashable {

    typealias FromLine = WhitelistedPOSTagLine
    let line: FromLine
    let rank: Rank
    let homonym: Homonym?

    struct Other {
        let rank: Rank
        let homonym: Homonym?
    }

    init(line: FromLine, other: Other) {
        self.line = line
        self.rank = other.rank
        self.homonym = other.homonym
    }

    init(line: FromLine, rank: Rank, homonym: Homonym?) {
        self.line = line
        self.rank = rank
        self.homonym = homonym
    }
}


extension HomonymLine {
    var isHomonym: Bool {
        homonym != nil
    }
}

// MARK: CustomStringConvertible
extension HomonymLine {
    var description: String {
        "rank: \(rank) - \(descriptionOfWord(wordForm, lemgrams: lemgrams))"
    }
}

// MARK: Equatable
extension HomonymLine {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.line == rhs.line
    }

}

// MARK: Hashable
extension HomonymLine {
    func hash(into hasher: inout Hasher) {
        hasher.combine(line)
    }
}
