//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

struct ElectJob: CacheableJob {
    let runContext: RunContext
}

extension ElectJob {
    typealias Input = NominatedLines
    typealias Output = ElectedLines

    func newWork(input: Input) throws -> Output {
        var electedLines = OrderedSet<ElectedLine>()

        let nominated: NominatedLine = input[0]
        let line = ElectedLine(line: nominated)
        electedLines.append(line)

        return ElectedLines(electedLines)
    }
}
