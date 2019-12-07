//
//  Line.swift
//  
//
//  Created by Alexander Cyon on 2019-10-23.
//

import Foundation

/// Some lines from the corpus:
///
///     Word form   Part Of Speech              Base form(s)                Compound?   Occurences      Relative frequency
///     ------------------------------------------------------------------------------------------------------------------
///     veckor      NN.UTR.PLU.IND.NOM          |vecka..nn.1|               -           2932870         220.342774
///     om          SN                          |om..sn.1|även_om..snm.1|   -           2930416         220.158409
///     va          IN                          |va..in.1|                  -           2910224         218.641409
///     fler        JJ.POS.UTR+NEU.PLU.IND.NOM  |                           -           2909834         218.612109
///     kvinnor     NN.UTR.PLU.IND.NOM          |kvinna..nn.1|              +           2903606         218.144207
///
public final class Line: Codable, CustomStringConvertible, Hashable, Comparable {

    // MARK: - Properties

    // MARK: Corpus properties

    /// The word, on lowercased form
    public let wordForm: WordForm

    /// Part of speech tag, only first major tag, .e.g from line `han    PN.UTR.SIN.DEF.SUB`, we only save `PN`
    public let partOfSpeechTag: PartOfSpeech

    /// Base form(s) of word
    public let canonicalFormsOfWord: CanonicalFormsOfWord

    /// Whether this is a compound word or not, an example of a compound word is 🇸🇪_"stämband"_,
    /// consisting of the word _"stäm"_ and the word _"band"_.
    public let isCompoundWord: Bool

    /// The total frequency, the number of occurences of the word form in the corpus.
    public let numberOfOccurencesInCorpus: Int

    /// The relative frequency of the word form in the corpus per 1 million words.
    public let relativeFrequencyPerOneMillion: Double

    // MARK: Meta properties

    /// The index of this parsed line in the corpus
    public let indexOfLineInCorpus: Int

    /// The index of this line instance in the collection of non-rejected lines.
    public let index: Int

    /// "Designated" initializer
    public init?(unparsedReadLine: UnparsedReadLine) throws {

        let parts = unparsedReadLine.unparsedLine.parts(separatedBy: Self.interLineDelimiter)

        guard parts.count == Self.numberOfComponents else {
            throw Error.unexpectedNumberOfComponents(got: parts.count)
        }


        do {
            self.word = try WordForm(linePart: parts[0])
        } catch let wordError as Word.Error {
            print("Skipped word: '\(parts[0])' (due to: \(wordError)")
            return nil
        }

        self.partOfSpeechTag = try PartOfSpeech(linePart: parts[1])
        self.canonicalFormsOfWord = try CanonicalFormsOfWord(linePart: parts[2])

        /// We expect the fourth part to just be a dash separating parts from numbers specifying occurences
        self.isCompoundWord = try IsCompoundWord(linePart: parts[3]).isCompoundWord

        guard let numberOfOccurencesInCorpus = Int(parts[4]) else {
            throw Error.stringNotAnInteger(parts[4])
        }

        self.numberOfOccurencesInCorpus = numberOfOccurencesInCorpus

        guard let relativeFrequencyPerOneMillion = Double(parts[5]) else {
            throw Error.stringNotADouble(parts[5])
        }
        self.relativeFrequencyPerOneMillion = relativeFrequencyPerOneMillion
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
        case stringNotADouble(String)
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
