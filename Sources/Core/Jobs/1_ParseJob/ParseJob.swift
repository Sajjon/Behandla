//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

struct ParseJob: CacheableJob {
    let runContext: RunContext
}

// MARK: CacheableJob
extension ParseJob {
    typealias Input = ScannedLines
    typealias Output = ParsedLines

    func newWork(input: Input) throws -> Output {
        var parsedLines = [ParsedLine]()

        for scannedLine in input.contents {
            guard let parsedLine = try? ParsedLine.fromScannedLine(scannedLine) else {
                continue
            }
            parsedLines.append(parsedLine)
        }

        return ParsedLines(parsedLines)
    }
}
