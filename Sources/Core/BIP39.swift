//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-10-23.
//

import Foundation

public enum BIP39 {}

public extension BIP39 {
    static let minimumWordLength = 3
    static let maximumWordLength = 10
    static let numberOfCharactersToUnambigiouslyIdentifyWord = 4
}

public extension BIP39 {
    final class Creator {

        let scanCorpusContext: ScanCorpusContext

        /// Whether or not we should cache intermediate results between runs
        let shouldCache: Bool

        init(
            fileNameOfInputCorpus: String,
            numberOfLinesToScan: Int,
            shouldCache: Bool
        ) {

            self.scanCorpusContext = ScanCorpusContext(
                fileNameOfInputCorpus: fileNameOfInputCorpus,
                numberOfLinesToScan: numberOfLinesToScan
            )

            self.shouldCache = shouldCache
        }
    }
}

public extension BIP39.Creator {
    func createWordList() throws {
        
        print("Creating word list 🌈: scanCorpusContext: \(scanCorpusContext), shouldCache: \(shouldCache)")

        let pipeline: Pipeline<ScanCorpusContext, String> = Pipeline {
            ScanCorpusJob(shouldCache: self.shouldCache)
            AnnounceFinishedJob()
        }

        let result = try pipeline.work(input: scanCorpusContext)
        print("🚀 result: \(result)")
    }
}

struct AnnounceFinishedJob: Job {
    typealias Input = ScannedLines
    func work(input: Input) throws -> String {
        "finished scanning #\(input.scannedLines.count) lines"
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

        let input = try readValue(for: "input", map: { $0 })  ?? "Assets/Input/corpus_first_million_lines.txt"
        let lineCount = try readValue(for: "lines") { Int($0) } ?? 2000
        let cache = try readValue(for: "cache") { Bool($0) } ?? true

        if let argumentLeft = arguments.first {
            throw Error.unrecognizedArgument(name: argumentLeft.key, value: argumentLeft.value)
        }

        self.init(
            fileNameOfInputCorpus: input,
            numberOfLinesToScan: lineCount,
            shouldCache: cache
        )
    }

    convenience init(arguments: [String]) throws {
        // The first argument - `arguments[0]` - is the execution path
        let arguments = [String](arguments.dropFirst())
        print("🇸🇪 \(arguments)")

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

public extension BIP39.Creator {
    enum Error: Swift.Error {
        case expectedEvenNumberOfArguments
        case expectedNamedArgumentToStartWithDoubleDash

        case foundValueForArgumentButItHadWrongType(
            argumentName: String,
            expectedType: Any.Type,
            fromStringValue: String
        )

        case unrecognizedArgument(name: String, value: String)
//        case missingFileName
//        case missingNumberOfLinesToRead
//        case numberOfLinesToReadNotAnInteger
//        case failedToReadFile(atPath: String)
//        case expectedWordCount(of: Int, butGot: Int)
    }
}
