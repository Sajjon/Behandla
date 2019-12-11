//
//  Line.swift
//  
//
//  Created by Alexander Cyon on 2019-10-23.
//

import Foundation

/// A parsed line from some scanned line in the corpus.
struct ParsedLine: LineFromCorpusComponents, Codable, Hashable {

    // MARK: - Properties

    // MARK: Corpus properties

    let wordForm: WordForm
    let partOfSpeechTag: PartOfSpeech
    let lemgrams: Lemgrams
    let isCompoundWord: Bool
    let numberOfOccurencesInCorpus: Int
    let relativeFrequencyPerOneMillion: Int

    // MARK: Meta properties
    let indexOfLineInCorpus: Int
}

extension ParsedLine {
    static func fromScannedLine(_ scannedLine: ScannedLine) throws -> Self {

        let parts = scannedLine.lineFromCorpus.parts(separatedBy: Self.interLineDelimiter)

        guard parts.count == Self.numberOfComponents else {
            throw WordError.unexpectedNumberOfComponents(got: parts.count, butExpected: Self.numberOfComponents)
        }


        let wordForm = try WordForm(linePart: parts[0])

        let partOfSpeechTag = try PartOfSpeech(linePart: parts[1])
        let lemgrams: Lemgrams

        do {
           lemgrams = try Lemgrams(linePart: parts[2])
        } catch {
            let lemgram = Lemgram(wordForm: wordForm, partOfSpeech: partOfSpeechTag)
            lemgrams = Lemgrams(single: lemgram)
        }

        /// We expect the fourth part to just be a dash separating parts from numbers specifying occurences
        let isCompoundWord = try IsCompoundWord(linePart: parts[3]).isCompoundWord

        guard let numberOfOccurencesInCorpus = Int(parts[4]) else {
            throw WordError.stringNotAnInteger(parts[4])
        }

        guard let relativeFrequencyPerOneMillionDouble = Double(parts[5]) else {
            throw WordError.stringNotADouble(parts[5])
        }
        let relativeFrequencyPerOneMillion = Int(relativeFrequencyPerOneMillionDouble)

        let indexOfLineInCorpus = scannedLine.positionInCorpus

        return Self(
            wordForm: wordForm,
            partOfSpeechTag: partOfSpeechTag,
            lemgrams: lemgrams,
            isCompoundWord: isCompoundWord,
            numberOfOccurencesInCorpus: numberOfOccurencesInCorpus,
            relativeFrequencyPerOneMillion: relativeFrequencyPerOneMillion,
            indexOfLineInCorpus: indexOfLineInCorpus
        )
    }
}

extension ParsedLine {

    /// Character used to separate parts within the line
    static let interLineDelimiter: Character = "\t"

    /// Character used to separate lines from one another
    static let intraLineDelimiter: Character = "\n"

    static let numberOfComponents: Int = 6
}
