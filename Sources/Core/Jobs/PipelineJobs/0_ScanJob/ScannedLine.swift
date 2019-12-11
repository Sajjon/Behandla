//
//  ScannedLine.swift
//  
//
//  Created by Alexander Cyon on 2019-10-23.
//

import Foundation

/// A scanned, but not yet parsed line. Scanned from the corpus.
struct ScannedLine: Hashable, Codable, CustomStringConvertible {

    private let l: String
    private let p: Int

    init(lineFromCorpus: String, positionInCorpus: Int) {
        l = lineFromCorpus
        p = positionInCorpus
    }
}

extension ScannedLine {
    var lineFromCorpus: String { l }
    var positionInCorpus: Int { p }
}

// MARK: CustomStringConvertible
extension ScannedLine {
    var description: String { lineFromCorpus }
}
