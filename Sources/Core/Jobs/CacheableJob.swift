//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

protocol CacheableJob: Job where Output: Codable {
    var shouldCache: Bool { get }
    var fileName: String { get }
    func newWork(input: Input) throws -> Output
}

extension CacheableJob {

    var fileName: String {
        var nameOfJob = name
        if nameOfJob.hasSuffix("Job") {
            nameOfJob = String(nameOfJob.dropLast(3))
        }
        return nameOfJob.lowercased() + ".json"
    }

    func work(input: Input) throws -> Output {
        let cacher = Cacher()
        if shouldCache, let cached: Output = try? cacher.load(name: fileName) {
            print("💾 found and reusing cached data in: '\(fileName)'")
            return cached
        }

        let newOutput = try newWork(input: input)
        if shouldCache {
            try cacher.save(newOutput, name: fileName)
        }
        return newOutput
    }
}
