//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-11.
//

import Foundation

// MARK: Homonym
struct Homonym: Hashable, CustomStringConvertible, Codable {
    let wordForm: WordForm
    let posTags: [PartOfSpeech]
    let lemgrams: Lemgrams
    init(word: WordForm, lemgrams: Lemgrams, posTags: [PartOfSpeech]) throws {
        guard posTags.count > 1 else {
            throw Error.aHomonymRequiresAtLeastTwoMeanings
        }
        self.wordForm = word
        self.lemgrams = lemgrams
        self.posTags = posTags
    }
}

extension Homonym {

    enum Error: Swift.Error, Equatable {
        case aHomonymRequiresAtLeastTwoMeanings
    }

    var count: Int {
        //        max(posTags.count, lemgrams.count)
        posTags.count
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.wordForm == rhs.wordForm
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(wordForm)
    }
}

extension Homonym {
    var description: String {
       descriptionOfWord(wordForm, lemgrams: lemgrams)
    }
}

func descriptionOfWord(_ wordForm: WordForm, lemgrams: Lemgrams) -> String {
    [
        wordForm.pad(),
        lemgrams.description
    ].joined(separator: "\t")
}
