//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

protocol OrderedSetOwner: RandomAccessCollection, ExpressibleByArrayLiteral, Codable, Hashable, CustomStringConvertible
where
Element: Hashable & Codable, Index == Int
{
    var orderedSet: OrderedSet<Element> { get }
    init(_ elements: OrderedSet<Element>)
}

// MARK: CustomStringConvertible
extension OrderedSetOwner {
    var description: String {
        String(describing: contents)
    }
}

// MARK: Codable
extension OrderedSetOwner {

    func encode(to encoder: Encoder) throws {
        var singleValueContainer = encoder.singleValueContainer()
        try singleValueContainer.encode(contents)
    }

    init(from decoder: Decoder) throws {
        let singleValueContainer = try decoder.singleValueContainer()
        let array = try singleValueContainer.decode([Element].self)
        self.init(OrderedSet(array: array))
    }

    init(arrayLiteral elements: Element...) {
        self.init(OrderedSet(array: elements))
    }

}

// MARK: Collection
extension OrderedSetOwner {

    var contents: [Element] { orderedSet.contents }
    var startIndex: Index { contents.startIndex }
    var endIndex: Index { contents.endIndex }

    subscript(index: Index) -> Element { contents[index] }

    func index(after index: Index) -> Index {
        orderedSet.index(after: index)
    }

}
