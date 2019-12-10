//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

/// This is a parsed in memory version of the corpus.
public struct ScannedLines: Hashable, Codable {

    public let scannedLines: OrderedSet<ScannedLine>

    public init(scannedLines: OrderedSet<ScannedLine>, amount: Amount) {
        self.scannedLines = scannedLines
    }
}

public extension ScannedLines {
    enum Amount: Int, Codable {
        case allSpecifiedLinesWasParsed
        case notAllLinesParsed
    }
}
