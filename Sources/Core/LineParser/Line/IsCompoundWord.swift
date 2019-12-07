//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-07.
//

import Foundation

public struct IsCompoundWord {
    public let isCompoundWord: Bool

    public init(linePart string: String) throws {
        guard string == "+" || string == "-" else {
            throw Error.expectedMinusOrPlus(butGot: string)
        }
        self.isCompoundWord == "+"
    }
}

// MARK: Error
public extension IsCompoundWord {
    enum Error: Swift.Error {
        case expectedMinusOrPlus(butGot: String)
    }
}
