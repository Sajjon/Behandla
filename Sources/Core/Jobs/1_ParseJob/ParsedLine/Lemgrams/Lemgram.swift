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

    init(baseForm: BaseForm, partOfSpeech: PartOfSpeech, index: Int = 0) {
        self.b = baseForm
        self.p = partOfSpeech
        self.i = index
    }

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

        self.init(
            baseForm: try BaseForm(linePart: word),
            partOfSpeech: try PartOfSpeech(linePart: posAndIndexComponents[0]),
            index: index
        )
    }
}

extension Lemgram {

    var baseForm: BaseForm { b }
    var partOfSpeech: PartOfSpeech { p }
    var index: Int { i }
}

// MARK: Equatable
extension Lemgram {
    static func == (lhs: Self, rhs: Self) -> Bool {
        // omit `index`
        lhs.baseForm == rhs.baseForm && lhs.partOfSpeech == rhs.partOfSpeech
    }
}

// MARK: Hashable
extension Lemgram {
    func hash(into hasher: inout Hasher) {
        // omit `index`
        hasher.combine(baseForm)
        hasher.combine(partOfSpeech)
    }
}

extension Lemgram {
    struct BaseForm: WordFromString, Codable, Hashable {
        private let w: String

        init(linePart anyCase: String) throws {
            self.w = try Self.from(unvalidatedString: anyCase)
        }

        init(wordForm: WordForm) {
            self.w = wordForm.lowercasedWord
        }
    }
}

extension Lemgram {

    init(wordForm: WordForm, partOfSpeech: PartOfSpeech, index: Int = 0) {
        self.init(
            baseForm: BaseForm(wordForm: wordForm),
            partOfSpeech: partOfSpeech,
            index: index
        )
    }
}

extension Lemgram.BaseForm {
    var word: String { w }
}

extension Lemgram {
    var description: String {
        """
        \(baseForm.word) (\(partOfSpeech))
        """
    }
}
