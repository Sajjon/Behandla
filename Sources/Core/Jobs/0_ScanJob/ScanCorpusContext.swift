//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

struct ScanCorpusContext: LinesCountable, Codable {
    /// Name of corpus file to scan
    public let fileNameOfInputCorpus: String

    /// How many lines to scan
    public let numberOfLinesToScan: Int
}

extension ScanCorpusContext {
    var numberOfLines: Int { numberOfLinesToScan }
}
