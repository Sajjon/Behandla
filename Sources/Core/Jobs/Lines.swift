//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

typealias Lines<Line> = LinesWithContext<Line, Void> where Line: LineFromCorpusConvertible

struct LinesWithContext<Line, Context>: ExpressibleByCollection, Codable where Line: LineFromCorpusConvertible {

    typealias Element = Line

    let contents: [Line]
    init(_ lines: [Line]) {
        self.contents = lines
    }
}

extension LinesWithContext {
    var lines: [Line] { contents }
    var numberOfLines: Int { count }
}

extension LinesWithContext: Equatable where Line: Equatable {}
extension LinesWithContext: Hashable where Line: Hashable {}
