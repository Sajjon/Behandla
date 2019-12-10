//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-10-23.
//

import Foundation

/// This is a parsed in memory version of the corpus.
public struct ParsedLines: Hashable, Codable, LinesCountable {
    public let parsedLines: OrderedSet<ParsedLine>

}

public extension ParsedLines {
    var numberOfLines: Int { parsedLines.count }
}
