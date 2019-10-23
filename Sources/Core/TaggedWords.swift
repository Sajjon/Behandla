//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-10-23.
//

import Foundation

///
/// This is a parsed in memory version of the corpus.
/// Download corpus with POS tagged word stats [here][1]
///
/// [1]: https://svn.spraakdata.gu.se/sb-arkiv/pub/frekvens/stats_PAROLE.txt
public struct TaggedWords: Codable {
    public let linesOfTaggedWords: OrderedSet<Line>
    public init(lines: OrderedSet<Line>, result: Result) {
        self.linesOfTaggedWords = lines
        print(result)
    }
}

public extension TaggedWords {
    func homonyms(minimumNumberOfPartOfSpeechTags: Int = 2) -> OrderedSet<Line> {
        OrderedSet(array: linesOfTaggedWords.filter { $0.partOfSpeechTags.count >= minimumNumberOfPartOfSpeechTags })
    }
}

public extension TaggedWords {
    enum Result: Int, Codable {
        case allSpecifiedLinesWasParsed
        case notAllLinesParsed
    }
}
