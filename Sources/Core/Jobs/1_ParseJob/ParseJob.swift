//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

struct ParseJob: CacheableJob {
    let shouldCache: Bool
}

// MARK: CacheableJob
extension ParseJob {
    typealias Input = ScannedLines
    typealias Output = ParsedLines

    func newWork(input: Input) throws -> Output {
        var parsedLines = OrderedSet<ParsedLine>()
        for scannedLine in input.scannedLines {
            guard let parsedLine = try? ParsedLine(scannedLine: scannedLine) else {
                continue
            }

            parsedLines.append(parsedLine)
        }

        return ParsedLines(parsedLines: parsedLines, amount: .allSpecifiedLinesWasParsed)
    }
}
