//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

protocol LineFromCorpusFromLineAndOther: LineFromCorpusConvertibleByProxy {
    associatedtype Other
    init(line: FromLine, other: Other)
}

protocol LineFromCorpusFromLine: LineFromCorpusFromLineAndOther where Other == Void {
    init(line: FromLine)
}

extension LineFromCorpusFromLine {
    init(line: FromLine, other: Void) {
        self.init(line: line)
    }
}

//extension LineFromCorpusFromLineAndOther where Other == Void {
//    init(line: FromLine) {
//        self.init(line: line, other: ())
//    }
//}
