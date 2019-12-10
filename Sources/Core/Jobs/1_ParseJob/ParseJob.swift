//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

struct ParseJob: Job {
    let shouldCache: Bool
}

// MARK: Job
extension ParseJob {
    typealias Input = ScannedLines
    typealias Output = ParsedLines

    func work(input: Input) throws -> Output {
        var parsedLines = OrderedSet<ParsedButNotYetProcessedLine>()
        for scannedLine in input.scannedLines {
            guard let parsedLine = try? ParsedButNotYetProcessedLine(scannedLine: scannedLine) else {
                continue
            }

            parsedLines.append(parsedLine)
        }

        return ParsedLines(parsedLines: parsedLines, amount: .allSpecifiedLinesWasParsed)
    }
}
