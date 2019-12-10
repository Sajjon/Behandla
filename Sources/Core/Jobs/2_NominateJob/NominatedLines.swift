//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

/// This is a parsed in memory version of the corpus.
public struct NominatedLines: Hashable, Codable {
    public let lines: OrderedSet<NominatedLine>
}
