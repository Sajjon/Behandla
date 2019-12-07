//
//  Word.swift
//  
//
//  Created by Alexander Cyon on 2019-10-23.
//

import Foundation

public struct WordForm: CustomStringConvertible, Hashable, Comparable, Codable {

    public let lowercasedWord: String

    init(linePart anyCase: String) throws {
        let lowercased = anyCase.lowercased()

        let length = lowercased.count

        if length > Self.maximumLength {
            throw Error.tooLong(gotLength: length)
        }

        if length < Self.minimumLength {
            throw Error.tooShort(gotLength: length)
        }

        guard CharacterSet(charactersIn: lowercased).isSubset(of: Self.allowedCharacterSet) else {
            throw Error.disallowedCharacter(invalid: lowercased)
        }

        self.lowercasedWord = lowercased
    }
}

// MARK: CustomStringConvertible
public extension WordForm {
    var description: String { lowercasedWord }
}

// MARK: Comparable
public extension WordForm {
    static func < (lhs: WordForm, rhs: WordForm) -> Bool {
        lhs.lowercasedWord < rhs.lowercasedWord
    }
}

// MARK: Constants
public extension WordForm {
    static let allowedCharacter = "abcdefghijklmnopqrstuvwxyzåäö"
    static let allowedCharacterSet = CharacterSet(charactersIn: Self.allowedCharacter)
    static let minimumLength = 3
    static let maximumLength = 10
}

// MARK: Error
public extension WordForm {
    enum Error: Swift.Error {

        case tooLong(
            gotLength: Int,
            butExpectedAtMost: Int = WordForm.maximumLength
        )

        case tooShort(
            gotLength: Int,
            butExpectedAtLeast: Int = WordForm.minimumLength
        )

        case disallowedCharacter(
            invalid: String,
            expectedOnlyAnyOf: String = WordForm.allowedCharacter
        )
    }
}

// MARK: Hashabble
public extension WordForm {
    func hash(into hasher: inout Hasher) {
        // We only care about the first characters, since we need to be able to disambituate fast.
        let prefix = String(lowercasedWord.prefix(BIP39.numberOfCharactersToUnambigiouslyIdentifyWord))

        hasher.combine(prefix)
    }
}

public extension WordForm {

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
