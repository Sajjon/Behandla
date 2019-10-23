//
//  Line.swift
//  
//
//  Created by Alexander Cyon on 2019-10-23.
//

import Foundation

/// Below follows an example of 6 lines from the corpus
///
///     till    PP    |till..pp.1|    -    183125    7535.048209
///     "    PAD    |    -    174001    7159.622790
///     den    DT.UTR.SIN.DEF    |en..al.1|den..pn.1|    -    141582    5825.677519
///     ett    DT.NEU.SIN.IND    |en..al.1|    -    133832    5506.788106
///     -    MID    |    -    131135    5395.814591
///     han    PN.UTR.SIN.DEF.SUB    |han..pn.1|    -    125071    5146.299056
///
///
public final class Line: Codable, CustomStringConvertible, Hashable, Comparable {

    /// Absolut position in corpus at its earliest position
    public private (set) var lines: [Int]

    /// The word, on lowercased form
    public let word: Word

    /// Part of speech tag, only first major tag, .e.g from line `han    PN.UTR.SIN.DEF.SUB`, we only save `PN`/
    public private (set) var partOfSpeechTags: [PartOfSpeech]

    /// Base form of word
    public private (set) var canonicalFormsOfWord: CanonicalFormsOfWord

    public private (set) var numberOfOccurencesInCorpus: Int

    init?(unparsedReadLine: UnparsedReadLine) throws {

        let parts = unparsedReadLine.unparsedLine.parts(separatedBy: Self.interLineDelimiter)

        guard parts.count == Self.numberOfComponents else {
            throw Error.unexpectedNumberOfComponents(got: parts.count)
        }

        self.lines = [unparsedReadLine.positionInCorpus]

        do {
            self.word = try Word(linePart: parts[0])
        } catch { // let wordError as Word.Error {
//            print("Skipped word: '\(parts[0])' (due to: \(wordError)")
            return nil
        }

        self.partOfSpeechTags = [try PartOfSpeech(linePart: parts[1])]
        self.canonicalFormsOfWord = try CanonicalFormsOfWord(linePart: parts[2])

        /// We expect the fourth part to just be a dash separating parts from numbers specifying occurences
        guard parts[3].count == 1 else {
            fatalError("Unexpected length delimiter: '\(parts[3])'")
        }

        guard let numberOfOccurencesInCorpus = Int(parts[4]) else {
            throw Error.stringNotAnInteger(parts[4])
        }

        self.numberOfOccurencesInCorpus = numberOfOccurencesInCorpus
    }
}

public extension Line {
    func update(with other: Line) {
        guard other == self else {
            fatalError("not same word, abort.")
        }
        self.lines.append(contentsOf: other.lines)
        self.numberOfOccurencesInCorpus += other.numberOfOccurencesInCorpus
        self.partOfSpeechTags = (partOfSpeechTags + other.partOfSpeechTags).removingDuplicates()
        self.canonicalFormsOfWord = canonicalFormsOfWord.merged(with: other.canonicalFormsOfWord)
    }
}

public extension Line {

    /// Character used to separate parts within the line
    static let interLineDelimiter: Character = "\t"

    /// Character used to separate lines from one another
    static let intraLineDelimiter: Character = "\n"

    static let numberOfComponents: Int = 6
}

// MARK: Error
public extension Line {
    enum Error: Swift.Error {

        case unexpectedNumberOfComponents(
            got: Int,
            butExpected: Int = Line.numberOfComponents
        )

        case stringNotAnInteger(String)
    }
}

// MARK: Equtable
public extension Line {
    static func == (lhs: Line, rhs: Line) -> Bool {
        lhs.word == rhs.word
    }
}


// MARK: Hashable
public extension Line {
    func hash(into hasher: inout Hasher) {
        hasher.combine(word)
    }
}

// MARK: Comparable
public extension Line {
    static func < (lhs: Line, rhs: Line) -> Bool {
        lhs.word < rhs.word
    }
}

// MARK: CustomStringConvertible
public extension Line {
    var description: String {
        """
        \(word), pos: \(partOfSpeechTags), base: [\(canonicalFormsOfWord)]
        """
    }
}


internal func castErrorOrKill<Error>(_ anyError: Swift.Error) -> Error where Error: Swift.Error {
    guard let error = anyError as? Error else {
        fatalError("Wrong error type, got error: \(anyError), but expected error of type: \(type(of: Error.self))")
    }
    return error
}

// MARK: Codable
public extension Line {
    enum CodingKeys: String, CodingKey {

        case partOfSpeechTags = "posTags"
        case canonicalFormsOfWord = "base"
        case numberOfOccurencesInCorpus = "occurences"

        case lines
        case word
    }
}
