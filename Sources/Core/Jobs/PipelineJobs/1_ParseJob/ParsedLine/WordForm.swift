//
//  Word.swift
//  
//
//  Created by Alexander Cyon on 2019-10-23.
//

import Foundation

struct WordForm:
    WordFromString,
    CustomStringConvertible,
    Hashable,
    Codable,
    ExpressibleByStringLiteral
{

    let lowercasedWord: String

    init(linePart anyCase: String) throws {
        self.lowercasedWord = try Self.from(unvalidatedString: anyCase)
    }
}


// MARK: ExpressibleByStringLiteral
extension WordForm {
    init(stringLiteral string: String) {
        do {
            try self.init(linePart: string)
        } catch {
            fatalError("Bad literal: \(error)")
        }
    }
}

// MARK: CustomStringConvertible
extension WordForm {
    var description: String { lowercasedWord }
}

//// MARK: Hashable
//extension WordForm {
//    func hash(into hasher: inout Hasher) {
//        // We only care about the first characters, since we need to be able to disambituate fast.
//        let prefix = String(lowercasedWord.prefix(BIP39.numberOfCharactersToUnambigiouslyIdentifyWord))
//
//        hasher.combine(prefix)
//    }
//}

extension WordForm {

    func encode(to encoder: Encoder) throws {
        var singleValueContainer = encoder.singleValueContainer()
        try singleValueContainer.encode(lowercasedWord)
    }

    init(from decoder: Decoder) throws {
        let singleValueContainer = try decoder.singleValueContainer()
        let unchecked = try singleValueContainer.decode(String.self)
        try self.init(linePart: unchecked)
    }

}
