//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

struct ScanCorpusJob {

    public let shouldCache: Bool
    public let announceEveryNthScannedLine = 100
}

// MARK: Job
extension ScanCorpusJob: Job {
    func work(input scanCorpusContext: ScanCorpusContext) throws -> ScannedLines {
        let file = try openFile(named: scanCorpusContext.fileNameOfInputCorpus)
        let lineReader = try LineScanner(file: file)

        print("✅ Starting to scan lines")

        let numberOfLinesToScan = scanCorpusContext.numberOfLinesToScan
        var scannedLines = OrderedSet<ScannedButNotYetParsedLine>()

        for lineIndex in 0...numberOfLinesToScan {

            if lineIndex % announceEveryNthScannedLine == 0 {
                print("📢 scanned #\(lineIndex) lines")
            }

            guard let rawLine: String = lineReader.nextLine() else {
                if lineIndex < numberOfLinesToScan {
                    print("⚠️ Warning Did not scan #\(numberOfLinesToScan) lines as requested, scanned #\(lineIndex) lines.")
                }
                print("Line nil, stopping...")
                return ScannedLines(scannedLines: scannedLines, amount: .notAllLinesParsed)
            }

            let scannedLine = ScannedButNotYetParsedLine(unparsedLine: rawLine, positionInCorpus: lineIndex)
            scannedLines.append(scannedLine)
        }

        return ScannedLines(scannedLines: scannedLines, amount: .allSpecifiedLinesWasParsed)
    }
}


private extension ScanCorpusJob {
    func openFile(named fileName: String) throws -> FileHandle {
        do {
            let path = URL(fileURLWithPath: fileName)
            return try FileHandle(forReadingFrom: path)
        }  catch {
            throw Error.failedToReadFile(atPath: fileName)
        }
    }

}

extension ScanCorpusJob {
        enum Error: Swift.Error {

            case failedToReadFile(atPath: String)

//            case missingFileName
//            case missingNumberOfLinesToRead
//            case numberOfLinesToReadNotAnInteger
//            case expectedWordCount(of: Int, butGot: Int)
    }

}
