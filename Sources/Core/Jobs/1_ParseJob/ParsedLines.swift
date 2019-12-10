//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-10-23.
//

import Foundation

/// This is a parsed in memory version of the corpus.
public struct ParsedLines: Hashable, Codable {

    public let parsedLines: OrderedSet<ParsedLine>

    public init(parsedLines: OrderedSet<ParsedLine>, amount: Amount) {
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
