//
//  CanonicalFormsOfWord.swift
//  
//
//  Created by Alexander Cyon on 2019-10-23.
//

import Foundation

public struct CanonicalFormsOfWord: CustomStringConvertible, Codable {

    public let baseForms: [String]

    internal init(removingDuplicates baseForms: [String]) {
        self.baseForms = baseForms.removingDuplicates()
    }

    /// Zero to many base forms of a word, delimited by `|`
    ///
    /// See the example of lines below
    ///
    ///     ===============================================================================================================
    ///     Col0        Col1                        Col2                        Col3        Col4            Col5
    ///     ===============================================================================================================
    ///     Word form   Part Of Speech              Base form(s)                Compound?   Occurences      Relative frequency
    ///     ===============================================================================================================
    ///     veckor      NN.UTR.PLU.IND.NOM          |vecka..nn.1|               -           2932870         220.342774
    ///     om          SN                          |om..sn.1|även_om..snm.1|   -           2930416         220.158409
    ///     va          IN                          |va..in.1|                  -           2910224         218.641409
    ///     fler        JJ.POS.UTR+NEU.PLU.IND.NOM  |                           -           2909834         218.612109
    ///     kvinnor     NN.UTR.PLU.IND.NOM          |kvinna..nn.1|              +           2903606         218.144207
    ///
    /// We can see tha the second line, with base forms of the word `"om"` contains two base forms,
    /// whereas the first only contained one, and the fourth zero.
    ///
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
