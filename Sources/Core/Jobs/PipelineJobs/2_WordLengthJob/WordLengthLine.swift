//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

/// A line which word has suitable length
struct WordLengthLine: LineFromCorpusFromLine, Hashable {
    typealias FromLine = ParsedLine
    let line: FromLine
}
