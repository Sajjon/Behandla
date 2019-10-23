//
//  CanonicalFormsOfWord.swift
//  
//
//  Created by Alexander Cyon on 2019-10-23.
//

import Foundation

extension Array where Element: Hashable {
    func removingDuplicates() -> Self {
        return [Element](Set<Element>(self))
    }
}

public struct CanonicalFormsOfWord: CustomStringConvertible, Codable {

    public let baseForms: [String]

    private init(removingDuplicates baseForms: [String]) {
        self.baseForms = baseForms.removingDuplicates()
    }

    /// Zero to many base forms of a word, delimited by `|`
    ///
    /// See the example of six lines below
    ///
    ///     Men    KN    |men..kn.1|    -    63570    2615.716121
    ///     :    MID    |    -    63104    2596.541609
    ///     vi    PN.UTR.PLU.DEF.SUB    |vi..pn.1|    -    63037    2593.784759
    ///     det    DT.NEU.SIN.DEF    |en..al.1|den..pn.1|    -    62891    2587.777294
    ///     hon    PN.UTR.SIN.DEF.SUB    |hon..pn.1|    -    59411    2444.585661
    ///     minst    AB.SUV    |minst..ab.1|liten..av.1|lite..ab.1|föga..ab.1|    -    5728    235.690136
    ///
    /// We can see tha the last line, with base forms of the word `"minst"` contains four base forms,
    /// whereas the first only contained one, and the second zero
    public init(linePart string: String) throws {
        let parts = string.parts(separatedBy: Self.delimiter)

        var baseForms = [String]()
        for part in parts {
            let splittable = part.replacingOccurrences(of: "..", with: String(Self.madeUpCustomTemporaryDelimiter))
            let innerParts = splittable.parts(separatedBy: Self.madeUpCustomTemporaryDelimiter)
            guard innerParts.count == 2 else {
                fatalError("Expected two inner parts, but got: \(innerParts.count)")
            }
            guard let baseFormNotCleaned = innerParts.first else {
                fatalError("Bad parsing of linePart `\(string)`, specifically part: `\(part)`")
            }

            let innerInnerParts = baseFormNotCleaned.parts(separatedBy: Self.innerPartDelimiter)

            guard let baseForm = innerInnerParts.first else {
                fatalError("Bad parsing of linePart `\(string)`, specifically inner part: `\(baseFormNotCleaned)`")
            }
            baseForms.append(baseForm)
        }

        self.init(removingDuplicates: baseForms)
    }
}

public extension CanonicalFormsOfWord {
    func merged(with other: Self) -> Self {
        return Self(removingDuplicates: self.baseForms + other.baseForms)
    }
}

public extension CanonicalFormsOfWord {
    var description: String { return baseForms.joined(separator: ", ") }
}

public extension CanonicalFormsOfWord {
    static let delimiter: Character = "|"
    static let madeUpCustomTemporaryDelimiter: Character = "¶"
    static let innerPartDelimiter: Character = "_"
}

extension String {
    func parts(separatedBy delimiter: Character) -> [String] {
        split(separator: delimiter).map { String($0) }
    }
}

public extension CanonicalFormsOfWord {

    func encode(to encoder: Encoder) throws {
        var singleValueContainer = encoder.singleValueContainer()
        try singleValueContainer.encode(baseForms)
    }

    init(from decoder: Decoder) throws {
        let singleValueContainer = try decoder.singleValueContainer()
        self.baseForms = try singleValueContainer.decode([String].self)
    }

}
