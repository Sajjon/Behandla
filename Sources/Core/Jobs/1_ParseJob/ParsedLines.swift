//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-10-23.
//

import Foundation

/// This is a parsed in memory version of the corpus.
public struct ParsedLines: Codable {

    public let parsedLines: OrderedSet<ParsedButNotYetProcessedLine>

    public init(parsedLines: OrderedSet<ParsedButNotYetProcessedLine>, amount: Amount) {
        self.parsedLines = parsedLines
        print(amount)
    }
}

public extension ParsedLines {
    enum Amount: Int, Codable {
        case allSpecifiedLinesWasParsed
        case notAllLinesParsed
    }
}
