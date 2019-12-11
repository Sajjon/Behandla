//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-11.
//

import Foundation

/// Lines where words have suitable part of speech
typealias WhitelistedPOSTagLines = Lines<WhitelistedPOSTagLine>

/// A line which word has suitable part of speech
struct WhitelistedPOSTagLine: LineFromCorpusFromLine, Hashable {
    typealias FromLine = WordLengthLine
    let line: FromLine
}
