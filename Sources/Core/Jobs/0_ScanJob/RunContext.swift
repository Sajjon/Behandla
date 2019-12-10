//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

final class RunContext: CustomStringConvertible {

    /// Name of corpus file to scan
    let fileNameOfInputCorpus: String

    /// How many lines to scan
    let numberOfLinesToScan: Int

    /// Whether or not we should cache intermediate results between runs
    var shouldLoadCachedInput: Bool
    var shouldCachedOutput: Bool

    init(
        fileNameOfInputCorpus: String,
        numberOfLinesToScan: Int,
        shouldLoadCachedInput: Bool,
        shouldCachedOutput: Bool
    ) {
        self.fileNameOfInputCorpus = fileNameOfInputCorpus
        self.numberOfLinesToScan = numberOfLinesToScan
        self.shouldLoadCachedInput = shouldLoadCachedInput
        self.shouldCachedOutput = shouldCachedOutput
    }
}

extension RunContext {
    var description: String {
        "input: \(fileNameOfInputCorpus), #lines: \(numberOfLinesToScan), loadFromCache: \(shouldLoadCachedInput), saveToCache: \(shouldCachedOutput)"
    }
}
