//
//  Lemgrams.swift
//  
//
//  Created by Alexander Cyon on 2019-10-23.
//

import Foundation

public struct Lemgrams: Collection, Codable, Hashable, CustomStringConvertible {

    public let lemgramsSet: OrderedSet<Lemgram>

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

        self.lemgramsSet = lemgrams
    }
}

public extension Lemgrams {
    var description: String {
        String(describing: contents)
    }
}

public extension Lemgrams {
    static let delimiter: Character = "|"
}

public extension Lemgrams {

    func encode(to encoder: Encoder) throws {
        var singleValueContainer = encoder.singleValueContainer()
        try singleValueContainer.encode(contents)
    }

    init(from decoder: Decoder) throws {
        let singleValueContainer = try decoder.singleValueContainer()
        let array = try singleValueContainer.decode([Lemgram].self)
        self.lemgramsSet = OrderedSet.init(array: array)
    }

}

public extension Lemgrams {
    typealias Element = Lemgram
    typealias Index = Int


    var contents: [Lemgram] { lemgramsSet.contents }
    var startIndex: Index { contents.startIndex }
    var endIndex: Index { contents.endIndex }

    subscript(index: Index) -> Element { contents[index] }

    func index(after index: Index) -> Index {
        lemgramsSet.index(after: index)
    }

}
