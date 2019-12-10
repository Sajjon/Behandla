//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-08.
//

import Foundation

public struct Lemgram: CustomStringConvertible, Hashable, Codable {
    public let baseForm: BaseForm
    public let partOfSpeech: PartOfSpeech
    public let index: Int

    /// Expects a `{word}..{pos}.{index}` format, i.e. any `|` should already have been removed.
    public init(linePart string: String) throws {
        let components = string.components(separatedBy: "..")

        guard components.count == 2 else {
            throw WordError.unexpectedNumberOfComponents(got: components.count, butExpected: 2)
        }

        let word = components[0]
        let posAndIndexComponents = components[1].components(separatedBy: ".")

        guard posAndIndexComponents.count == 2 else {
            throw WordError.unexpectedNumberOfComponents(got: posAndIndexComponents.count, butExpected: 2)
        }

        guard let index = Int(posAndIndexComponents[1]) else {
            throw WordError.stringNotAnInteger(posAndIndexComponents[1])
        }


        self.baseForm = try BaseForm(linePart: word)

        self.partOfSpeech = try PartOfSpeech(linePart: posAndIndexComponents[0].uppercased())

        self.index = index
    }
}

public extension Lemgram {
    struct BaseForm: WordFromString, Codable, Hashable {
        public let word: String

        public init(linePart anyCase: String) throws {
            self.word = try Self.from(unvalidatedString: anyCase)
        }
    }
}

public extension Lemgram {
    var description: String {
        """
        \(index): \(baseForm.word) (\(partOfSpeech))
        """
    }
}
