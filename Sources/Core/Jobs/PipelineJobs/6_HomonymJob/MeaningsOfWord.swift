//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-11.
//

import Foundation


// MARK: MeaningsOfWord
struct MeaningsOfWord {
    let word: WordForm
    private(set) var lemgrams: OrderedSet<Lemgram>
    private(set) var posTags: OrderedSet<PartOfSpeech>

    init(for word: WordForm, lemgrams: Lemgrams, posTags: OrderedSet<PartOfSpeech> = .init()) {
        self.word = word
        self.lemgrams = OrderedSet(array: lemgrams.contents)
        self.posTags = posTags
    }
}

extension MeaningsOfWord {
    mutating func append(pos: PartOfSpeech, lemgrams: Lemgrams) {
        self.posTags.append(pos)
        self.lemgrams.append(contentsOf: lemgrams)
    }
}
