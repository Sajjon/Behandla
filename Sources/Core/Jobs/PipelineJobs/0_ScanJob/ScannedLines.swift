//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

/// This is a scanned in memory version of the corpus
struct ScannedLines: Codable {

    let contents: [ScannedLine]
    init(_ lines: [ScannedLine]) {
        self.contents = lines
    }
}

extension ScannedLines {
    var numberOfLines: Int { contents.count }
}
