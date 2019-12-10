//
//  ScannedLine.swift
//  
//
//  Created by Alexander Cyon on 2019-10-23.
//

import Foundation

/// A scanned, but not yet parsed line. Scanned from the corpus.
public struct ScannedLine: Hashable, Codable, CustomStringConvertible {
    public let lineFromCorpus: String
    public let positionInCorpus: Int
}

// MARK: CustomStringConvertible
public extension ScannedLine {
    var description: String { lineFromCorpus }
}
