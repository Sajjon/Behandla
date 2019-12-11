//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-07.
//

import Foundation

struct IsCompoundWord {
    let isCompoundWord: Bool

    init(linePart string: String) throws {
        guard string == "+" || string == "-" else {
            throw Error.expectedMinusOrPlus(butGot: string)
        }
        self.isCompoundWord = string == "+"
    }
}

// MARK: Error
extension IsCompoundWord {
    enum Error: Swift.Error {
        case expectedMinusOrPlus(butGot: String)
    }
}
