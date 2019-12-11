//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-11.
//

import Foundation

protocol ExpressibleByCollection: CollectionByProxy, ExpressibleByArrayLiteral {
    init(_ contents: [Element])
}

// MARK: ExpressibleByArrayLiteral
extension ExpressibleByCollection {
    init(arrayLiteral array: Element...) {
        self.init(array)
    }
}

// MARK: Codable
extension ExpressibleByCollection where Element: Codable {

    func encode(to encoder: Encoder) throws {
        var singleValueContainer = encoder.singleValueContainer()
        try singleValueContainer.encode(contents)
    }

    init(from decoder: Decoder) throws {
        let singleValueContainer = try decoder.singleValueContainer()
        self.init(try singleValueContainer.decode([Element].self))
    }
}
