//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

protocol CacheableJob: Job where Output: Codable {
    var runContext: RunContext { get }
    var fileName: String { get }
    func newWork(input: Input) throws -> Output
    func validateCached(_ cached: Output) throws
}

struct CachedJob<CachedData>: Codable where CachedData: Codable {
    let fileNameOfInputCorpus: String
    let numberOfLinesToScan: Int
    let cachedData: CachedData

    init(_ cachedDate: CachedData, context runContext: RunContext) {
        self.fileNameOfInputCorpus = runContext.fileNameOfInputCorpus
        self.numberOfLinesToScan = runContext.numberOfLinesToScan
        self.cachedData = cachedDate
    }
}

extension CacheableJob {

    var fileName: String {
        var name = nameOfJob
        if name.hasSuffix("Job") {
            name = String(name.dropLast(3))
        }
        return name.lowercased() + ".json"
    }

    /// Default, cached is good
    func validateCached(_ cached: Output) throws {}

    func work(input: Input) throws -> Output {
        let cacher = Cacher()
        let shouldLoadCachedInput = runContext.shouldLoadCachedInput

        if shouldLoadCachedInput, let cachedJob: CachedJob<Output> = try? cacher.load(name: fileName) {
            if runContext.fileNameOfInputCorpus == cachedJob.fileNameOfInputCorpus {

                do {
                    let cached = cachedJob.cachedData
                    try validateCached(cached)
                    print("🆗💾 found and reusing cached data in: '\(fileName)'")
                    return cached
                } catch {
                    print("🙅‍♀️💾 found cached date, but is invalid \(error), changing `shouldLoadCachedInput` to false")
                    runContext.shouldLoadCachedInput = false
                }
            } else {
                print("🙅‍♀️💾 found cached date, but not same corpus as this one, changing `shouldLoadCachedInput` to false")
                runContext.shouldLoadCachedInput = false
            }
        }

        let newOutput = try newWork(input: input)

        if runContext.shouldCachedOutput {
            print("🆕💾 caching new output of job: \(nameOfJob)")
            let toCache = CachedJob<Output>(newOutput, context: runContext)
            try cacher.save(toCache, name: fileName)
        }
        return newOutput
    }
}
