//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

struct RunContext: CustomStringConvertible {

    /// Name of corpus file to scan
    let fileNameOfInputCorpus: String

    /// How many lines to scan
    let numberOfLinesToScan: Int

    /// Step to start at, if nil, last cached step, given the `fileName`, is used, if the cached result
    /// contains number of lines >= `numberOfLinesToScan`.
    var startAtStep: Int?

    init(
        fileNameOfInputCorpus: String,
        numberOfLinesToScan: Int,
        startAtStep: Int?
    ) {
        self.fileNameOfInputCorpus = fileNameOfInputCorpus
        self.numberOfLinesToScan = numberOfLinesToScan
        self.startAtStep = startAtStep
    }
}

extension RunContext {
    var description: String {
        "input: \(fileNameOfInputCorpus), #lines: \(numberOfLinesToScan), startAtStep: \(startAtStep.map { "\($0)" } ?? "nil")"
    }
}
