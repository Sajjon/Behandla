//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-11.
//

import Foundation

// MARK: HomonymsBuilder
final class HomonymsBuilder {
    private(set) var map = [WordForm: MeaningsOfWord]()
    init() {}

}
extension HomonymsBuilder {
    func add(line: LineFromCorpusConvertible) {
        let word = line.wordForm
        var meanings: MeaningsOfWord = map[word] ?? MeaningsOfWord(for: word, lemgrams: line.lemgrams)
        meanings.append(pos: line.partOfSpeechTag, lemgrams: line.lemgrams)
        map[word] = meanings
    }

    func build() -> Homonyms {
        var homonyms = OrderedSet<Homonym>()
        for (word, meanings) in map {

            guard let homonym = try? Homonym(
                word: word,
                lemgrams: Lemgrams(meanings.lemgrams.contents),
                posTags: meanings.posTags.contents
                ) else { continue }

            homonyms.append(homonym)
        }
        return Homonyms(homonyms)
    }
}
