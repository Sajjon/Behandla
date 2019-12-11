//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

//typealias Lines<Line> = LinesWithContext<Line, Void> where Line: LineFromCorpusConvertible

struct Lines<Line>: ExpressibleByCollection, Codable where Line: LineFromCorpusConvertible {

    typealias Element = Line

    let contents: [Line]
    init(_ lines: [Line]) {
        self.contents = lines
    }
}

extension Lines {
    var lines: [Line] { contents }
    var numberOfLines: Int { count }
}

extension Lines: Equatable where Line: Equatable {}
extension Lines: Hashable where Line: Hashable {}
