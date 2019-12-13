//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

struct ScanJob {
    let runContext: RunContext
}

// MARK: Job
extension ScanJob: CacheableJob {

    typealias Input = RunContext
    typealias Output = ScannedLines

    func newWork(input runContext: Input) throws -> Output {
        let inputFileName = runContext.fileNameOfInputCorpus
        let file = try Cacher.currentDirectoryPath.openFile(named: inputFileName)

        let lineReader = try LineScanner(file: file)

        print("✅ Starting to scan lines")

        let numberOfLinesToScan = runContext.numberOfLinesToScan
        var scannedLines = [ScannedLine]()

        readlines: for lineIndex in 0...numberOfLinesToScan {

            guard let rawLine: String = lineReader.nextLine() else {
                if lineIndex < numberOfLinesToScan {
                    throw Error.notEnoughLinesScanned
                }
                break readlines
            }

            let scannedLine = ScannedLine(lineFromCorpus: rawLine, positionInCorpus: lineIndex)
            scannedLines.append(scannedLine)
        }

        return ScannedLines(scannedLines)
    }
}

extension ScanJob {
    enum Error: Swift.Error, Equatable {
        case notEnoughLinesScanned
    }
}
