//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

/// This is a parsed in memory version of the corpus.
public struct ScannedLines: Hashable, Codable, LinesCountable {

    public let scannedLines: OrderedSet<ScannedLine>

    public init(scannedLines: OrderedSet<ScannedLine>) {
        self.scannedLines = scannedLines
    }
}

public extension ScannedLines {
    var numberOfLines: Int { scannedLines.count }
}
