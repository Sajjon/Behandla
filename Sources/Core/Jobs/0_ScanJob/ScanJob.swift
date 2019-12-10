//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

struct ScanJob {

    public let shouldCache: Bool
    public let announceEveryNthScannedLine = 100
}

// MARK: Job
extension ScanJob: CacheableJob {

    typealias Input = ScanCorpusContext
    typealias Output = ScannedLines

    func newWork(input scanCorpusContext: Input) throws -> Output {
        let file = try Cacher.currentDirectoryPath.openFile(named: scanCorpusContext.fileNameOfInputCorpus)

        let lineReader = try LineScanner(file: file)

        print("✅ Starting to scan lines")

        let numberOfLinesToScan = scanCorpusContext.numberOfLinesToScan
        var scannedLines = OrderedSet<ScannedLine>()

        readlines: for lineIndex in 0...numberOfLinesToScan {

            if lineIndex % announceEveryNthScannedLine == 0 {
                print("📢 scanned #\(lineIndex) lines")
            }

            guard let rawLine: String = lineReader.nextLine() else {
                if lineIndex < numberOfLinesToScan {
                    throw Error.notEnoughLinesScanned
                }
//                return ScannedLines(scannedLines: scannedLines)
                break readlines
            }

            let scannedLine = ScannedLine(lineFromCorpus: rawLine, positionInCorpus: lineIndex)

            scannedLines.append(scannedLine)
        }

        return ScannedLines(scannedLines: scannedLines)
    }
}

extension ScanJob {
    enum Error: Swift.Error, Equatable {
        case notEnoughLinesScanned
    }
}
