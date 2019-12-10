//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-08.
//

import Foundation

public protocol Language {
    var allowedCharacter: String { get }
}

public extension Language {
    var allowedCharacterSet: CharacterSet { .init(charactersIn: allowedCharacter) }
}

public struct SupportedLanguage: Language {
    public let allowedCharacter: String
}

public extension SupportedLanguage {
    static let swedish = Self(allowedCharacter: "abcdefghijklmnopqrstuvwxyzåäö")
}
