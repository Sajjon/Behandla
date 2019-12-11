//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-10-23.
//

import Foundation

// MARK: BIP39
public enum BIP39 {}

extension BIP39 {
    static let minimumWordLength = 3

    /// BIP39 standard is in fact max of 8, but some languages deviate from this. Since
    /// Swedish is a languages using compound words a lot and words are in general quite lone
    /// we use a bigger max length.
    static let maximumWordLength = 11

    static let numberOfCharactersToUnambigiouslyIdentifyWord = 4
}

// MARK: Creator
public extension BIP39 {
    final class Creator {

        let runContext: RunContext

        init(
            fileNameOfInputCorpus: String,
            numberOfLinesToScan: Int,
            loadFromCache: Bool,
            saveToCache: Bool
        ) {
            self.runContext = RunContext(
                fileNameOfInputCorpus: fileNameOfInputCorpus,
                numberOfLinesToScan: numberOfLinesToScan,
                shouldLoadCachedInput: loadFromCache,
                shouldCachedOutput: saveToCache
            )
        }
    }
}

// MARK: Pipeline
public extension BIP39.Creator {
    func createWordList() throws {

        print("🚀 Started jobs, context: \(runContext)")

        let pipeline = Pipeline {
            ScanJob(runContext: runContext)
            ParseJob(runContext: runContext)
            NominateJob(runContext: runContext)
            ElectJob(runContext: runContext)
        }

        let result = try pipeline.work(input: runContext)
        let lines = result.prefix(runContext.numberOfLinesToScan)
        print("🔮 Done with pipeline:\n🕐 \(pipeline) 🕤\nResult of pipeline #\(lines.count) lines.")
    }
}

// MARK: Convenience Init
public extension BIP39.Creator {

    convenience init(arguments: [String: String]) throws {
        var arguments = arguments

        func readValue<Value>(
            for key: String,
            map: ((String) -> Value?)
        ) throws -> Value? {

            guard let stringValue = arguments[key] else { return nil }

            guard let value = map(stringValue) else {

                throw Error.foundValueForArgumentButItHadWrongType(
                    argumentName: key,
                    expectedType: Value.self,
                    fromStringValue: stringValue
                )
            }
            arguments.removeValue(forKey: key)
            return value
        }

        let input = try readValue(for: "input", map: { $0 })  ?? "Assets/Input/corpus_first_100k_lines.txt"
        let lineCount = try readValue(for: "lines") { Int($0) } ?? 50_000
        let loadFromCache = try readValue(for: "load") { Bool($0) } ?? true
        let saveToCache = try readValue(for: "save") { Bool($0) } ?? true

        if let argumentLeft = arguments.first {
            throw Error.unrecognizedArgument(name: argumentLeft.key, value: argumentLeft.value)
        }

        self.init(
            fileNameOfInputCorpus: input,
            numberOfLinesToScan: lineCount,
            loadFromCache: loadFromCache,
            saveToCache: saveToCache
        )
    }

    convenience init(arguments: [String]) throws {
        // The first argument - `arguments[0]` - is the execution path
        let arguments = [String](arguments.dropFirst())

        guard arguments.count % 2 == 0 else {
            throw Error.expectedEvenNumberOfArguments
        }

        let argumentPairsUnparsed = arguments.chunked(into: 2)
        var argumentPairs = [String: String]()
        for argumentPair in argumentPairsUnparsed {
            var name = argumentPair[0]
            if name.starts(with: "--") {
                name = String(name.dropFirst(2))
            } else {
                throw Error.expectedNamedArgumentToStartWithDoubleDash
            }
            argumentPairs[name] = argumentPair[1]
        }

        try self.init(arguments: argumentPairs)
    }
}

// MARK: Error
extension BIP39.Creator {
    enum Error: Swift.Error {
        case expectedEvenNumberOfArguments
        case expectedNamedArgumentToStartWithDoubleDash

        case foundValueForArgumentButItHadWrongType(
            argumentName: String,
            expectedType: Any.Type,
            fromStringValue: String
        )

        case unrecognizedArgument(name: String, value: String)
    }
}
