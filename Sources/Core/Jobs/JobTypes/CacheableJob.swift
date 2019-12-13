//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

struct AnyCacheableJob<Input, Output>: CacheableJob where Output: Codable {

//    private let _fileName: (String) -> String
    private let _newWork: (Input) throws -> Output
    private let _cachedIfValid: () throws -> Output
    let runContext: RunContext

    init<Concrete>(_ concrete: Concrete)
        where
        Concrete: CacheableJob,
        Concrete.Input == Input,
        Concrete.Output == Output
    {
//        self._fileName = { concrete.fileName(folder: $0) }
        self.runContext = concrete.runContext
        self._cachedIfValid = { try concrete.cachedIfValid() }
        self._newWork = { try concrete.newWork(input: $0) }
    }

//    func fileName(folder: String) -> String {
//        self._fileName(folder)
//    }

    func newWork(input: Input) throws -> Output {
        try self._newWork(input)
    }

//    func validateCached(_ cached: Output) throws {
//        try self._validateCached(cached)
//    }

    func cachedIfValid() throws -> Output {
        try self._cachedIfValid()
    }
}

protocol CacheableJob: Job where Output: Codable {
    var runContext: RunContext { get }
//    var corpusName: String { get }
//    var fileName: String { get }
    func newWork(input: Input) throws -> Output
//    func validateCached(_ cached: Output) throws
    func cachedIfValid() throws -> Output
}


enum CachedJobError: Int, Swift.Error, Equatable {
    case cachingDisabled
    case noCachedJobFound
    case inputFileMismatch
}

extension CacheableJob {

    var fileName: String {
        var name = nameOfJob
        if name.hasSuffix("Job") {
            name = String(name.dropLast(3))
        }
        let corpusName = runContext.fileNameOfInputCorpus
        return "\(corpusName)/\(name.lowercased()).json"
    }


    func cachedIfValid() throws -> Output {
        let cacher = Cacher()

        guard let cachedOutput: Output = try? cacher.load(name: fileName) else {
            throw CachedJobError.noCachedJobFound
        }

//        try validateCached(cachedOutput)
        return cachedOutput
    }

    func work(input: Input) throws -> Output {
        let newOutput = try newWork(input: input)

//        if let cached = try? cachedIfValid() {
//            print("🆗💾 found and reusing cached data in: '\(fileName)'")
//            return cached
//        }

        print("🆕💾 caching new output of job: \(nameOfJob)")
        let cacher = Cacher()
        try cacher.save(newOutput, name: fileName)
        return newOutput
    }
}
