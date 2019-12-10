//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

struct Lines<Line>: OrderedSetOwner where Line: Hashable & Codable {

    typealias Element = Line

    let orderedSet: OrderedSet<Line>
    init(_ lines: OrderedSet<Line>) {
        self.orderedSet = lines
    }

//    init(_ lines: OrderedSet<Line>) {
//        self.init(lines: lines)
//    }
}

extension Lines {
    var numberOfLines: Int { count }
}

