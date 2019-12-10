//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

protocol CacheableJob: Job where Input: Codable & LinesCountable, Output: Codable & LinesCountable {
    var shouldCache: Bool { get }
    var fileName: String { get }
    func newWork(input: Input) throws -> Output
}

extension CacheableJob {

    var fileName: String {
        var name = nameOfJob
        if name.hasSuffix("Job") {
            name = String(name.dropLast(3))
        }
        return name.lowercased() + ".json"
    }

    func work(input: Input) throws -> Output {
        let cacher = Cacher()
        if shouldCache, let cached: Output = try? cacher.load(name: fileName) {
            if cached.numberOfLines >= input.numberOfLines {
                print("💾 found and reusing cached data in: '\(fileName)'")
                return cached
            } else {
                print("💔💾 found cached date, but only #\(cached.numberOfLines) lines, but current job `\(self.nameOfJob)` requested at least #\(input.numberOfLines) lines.")
            }

        }

        let newOutput = try newWork(input: input)

        if shouldCache {
            try cacher.save(newOutput, name: fileName)
        }
        return newOutput
    }
}
