//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-08.
//

import Foundation

struct Lemgram: CustomStringConvertible, Hashable, Codable {
    private let b: BaseForm
    private let p: PartOfSpeech
    private let i: Int

    /// Expects a `{word}..{pos}.{index}` format, i.e. any `|` should already have been removed.
    init(linePart string: String) throws {
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


        self.b = try BaseForm(linePart: word)

        self.p = try PartOfSpeech(linePart: posAndIndexComponents[0].uppercased())

        self.i = index
    }
}

extension Lemgram {

    var baseForm: BaseForm { b }
    var partOfSpeech: PartOfSpeech { p }
    var index: Int { i }
}

extension Lemgram {
    struct BaseForm: WordFromString, Codable, Hashable {
        private let w: String

        init(linePart anyCase: String) throws {
            self.w = try Self.from(unvalidatedString: anyCase)
        }
    }
}

extension Lemgram.BaseForm {
    var word: String { w }
}

extension Lemgram {
    var description: String {
        """
        \(index): \(baseForm.word) (\(partOfSpeech))
        """
    }
}
