//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-08.
//

import Foundation

protocol Language {
    var allowedCharacter: String { get }
}

extension Language {
    var allowedCharacterSet: CharacterSet { .init(charactersIn: allowedCharacter) }
}

struct SupportedLanguage: Language {
    let allowedCharacter: String
}

extension SupportedLanguage {
    static let swedish = Self(allowedCharacter: "abcdefghijklmnopqrstuvwxyzåäö")
}
