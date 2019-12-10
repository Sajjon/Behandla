//
//  Lemgrams.swift
//  
//
//  Created by Alexander Cyon on 2019-10-23.
//

import Foundation

// MARK: Lemgrams
struct Lemgrams: OrderedSetOwner {
    typealias Element = Lemgram
    let orderedSet: OrderedSet<Lemgram>

    init(_ elements: OrderedSet<Element>) {
        self.orderedSet = elements
    }


    /// Input is the third column in the line:
    /// `|land..nn.3|land..nn.2|land..nn.1|`
    /// containing 0 to many lemgrams, in the case of zero lemgrams the string is only an single pipe `|`.
    init(linePart: String) throws {
        let parts = linePart.parts(separatedBy: Self.delimiter)

        var lemgrams = OrderedSet<Lemgram>()
        for part in parts {
            let lemgram = try Lemgram(linePart: part)
            lemgrams.append(lemgram)
        }

        self.init(lemgrams)
    }
}

extension Lemgrams {
    static let delimiter: Character = "|"
}
