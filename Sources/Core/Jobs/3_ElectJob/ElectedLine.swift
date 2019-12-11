//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

/// A line that has advanced from the nominated short list of lines, awaiting confirmation of becomming part of the 2048 BIP39 words.
struct ElectedLine: LineFromCorpusConvertibleByProxy, Hashable {
    typealias Line = NominatedLine
    let line: Line
    let rank: Rank
    let homonym: Homonym?
}


extension ElectedLine {
    var isHomonym: Bool {
        homonym != nil
    }
}

// MARK: CustomStringConvertible
extension ElectedLine {
    var description: String {
        "rank: \(rank) - \(descriptionOfWord(wordForm, lemgrams: lemgrams))"
    }
}

// MARK: Equatable
extension ElectedLine {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.line == rhs.line
    }

}

// MARK: Hashable
extension ElectedLine {
    func hash(into hasher: inout Hasher) {
        hasher.combine(line)
    }
}
