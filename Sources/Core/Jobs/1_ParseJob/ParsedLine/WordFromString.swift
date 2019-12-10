//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-08.
//

import Foundation

public protocol WordFromString {
    static func from(unvalidatedString: String, language: Language) throws -> String
}

public extension WordFromString {

    static func from(unvalidatedString: String, language: Language = SupportedLanguage.swedish) throws -> String {
        let lowercased = unvalidatedString.lowercased()

        guard CharacterSet(charactersIn: lowercased).isSubset(of: language.allowedCharacterSet) else {
            throw WordError.disallowedCharacter(
                invalid: lowercased,
                expectedOnlyAnyOf: language.allowedCharacter
            )
        }

        return lowercased
    }
}
