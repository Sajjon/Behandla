//
//  ScannedButNotYetParsedLine.swift
//  
//
//  Created by Alexander Cyon on 2019-10-23.
//

import Foundation

public struct ScannedButNotYetParsedLine: Hashable, Codable, CustomStringConvertible {
    public let unparsedLine: String
    public let positionInCorpus: Int
}

// MARK: CustomStringConvertible
public extension ScannedButNotYetParsedLine {
    var description: String { unparsedLine }
}
