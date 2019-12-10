//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-08.
//

import Foundation

public enum WordError: Swift.Error {
    case disallowedCharacter(
        invalid: String,
        expectedOnlyAnyOf: String
    )

    case unexpectedNumberOfComponents(
        got: Int,
        butExpected: Int
    )

    case stringNotAnInteger(String)
    case stringNotADouble(String)
}
