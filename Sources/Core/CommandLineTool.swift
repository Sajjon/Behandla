
import Foundation

public extension Set where Element == PartOfSpeech {
    static var blacklisted: Set<PartOfSpeech> {
        return Set([PartOfSpeech.foreignWord])
    }
}

public final class CommandLineTool {
    private let arguments: [String]
    private let announceMilestoneEveryNthLineRead: Int = 1000
    public init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
    }
}


private extension Line {
    var posCount: Int {
        partOfSpeechTags.count
    }
    var frequency: Int {
        numberOfOccurencesInCorpus
    }
}

public extension CommandLineTool {

    func run() throws {
        guard arguments.count > 1 else {
            throw Error.missingFileName
        }
        let taggedWords = try loadElseParseTaggedWords(fileName: "tagged_words.json")
        print("✅ taggedWords contains #\(taggedWords.linesOfTaggedWords.count) lines")

        let homonymsSortedDescendingPosTagCount = taggedWords.homonyms().sorted(by:
        { $0.posCount == $1.posCount ? $0.frequency > $1.frequency : $0.posCount > $1.posCount  }
        )

        print("⭐️ Found #\(homonymsSortedDescendingPosTagCount.count) homonyms")

        checkAgainstWhitelist(taggedWords)

        let bip39Words = try bip39WordList(from: OrderedSet(array: homonymsSortedDescendingPosTagCount), amount: 2600)

        try save(strings: bip39Words, outputFileName: "swedish.txt")
    }
}


private extension CommandLineTool {

    func bip39WordList(from setOfLines: OrderedSet<Line>, amount: Int) throws -> [String] {
        let words = [String](setOfLines.map { $0.word.lowercasedWord }.prefix(amount))
        guard words.count == amount else {
            throw Error.expectedWordCount(of: amount, butGot: words.count)
        }
        return words
    }

    func loadElseParseTaggedWords(fileName: String) throws -> TaggedWords {
        let forceParseANew = arguments.count > 3 && Bool(arguments[3]) == true

        let parse: () throws -> TaggedWords = { [unowned self] in
            return try self.parseCorpusGivenArguments(wordListFileName: fileName)
        }

        guard let taggedWords = try loadTaggedWordsFromFile(named: fileName) else {
            return try parse()
        }

        if forceParseANew {
            return try parse()
        }
        print("💾 Read tagged words from disc")
        return taggedWords
    }

    func loadTaggedWordsFromFile(named fileName: String) throws -> TaggedWords? {
        let file: FileHandle
        do {
            let path = URL(fileURLWithPath: fileName)
            file = try FileHandle(forReadingFrom: path)
        } catch {
            return nil
        }

        let contentsOfFile = file.readDataToEndOfFile()
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(TaggedWords.self, from: contentsOfFile)
    }

    func parseCorpusGivenArguments(wordListFileName: String) throws -> TaggedWords {

        guard arguments.count > 2 else {
            throw Error.missingNumberOfLinesToRead
        }

        // The first argument is the execution path
        let fileName = arguments[1]
        guard let numberOfLinesToRead = Int(arguments[2]) else {
            throw Error.numberOfLinesToReadNotAnInteger
        }
        let wordList = try parseCorpus(numberOfLinesToParse: numberOfLinesToRead, fileName: fileName)
        print("🌈 Parsed wordList, found: #\(wordList.linesOfTaggedWords.count) words")
        let outputFilePath = try saveWordList(wordList, outputFileName: wordListFileName)
        print("⭐️ Saved file at: \(outputFilePath)")
        return wordList
    }

    func parseCorpus(numberOfLinesToParse: Int, fileName: String, partOfSpeechBlackList: Set<PartOfSpeech> = .blacklisted) throws -> TaggedWords {
        let file = try openFile(named: fileName)
        let lineReader = try LineReader(file: file)
        print("✅ Starting to parse lines")
        var uniqueOrderedListOfLines = OrderedSet<Line>()
        for lineIndex in 0...numberOfLinesToParse {
            if lineIndex % announceMilestoneEveryNthLineRead == 0 {
                print("📢 parsed #\(lineIndex) lines")
            }
            guard let rawLine: String = lineReader.nextLine() else {
                if lineIndex < numberOfLinesToParse {
                    print("⚠️ Warning Did not read #\(numberOfLinesToParse) lines as requested, read #\(lineIndex) lines.")
                }
                print("Line nil, stopping...")
                return TaggedWords(lines: uniqueOrderedListOfLines, result: .notAllLinesParsed)
            }
            let unparsedLine = UnparsedReadLine(unparsedLine: rawLine, positionInCorpus: lineIndex)

            guard let line = try parse(line: unparsedLine) else {
                continue
            }

            guard let posTag = line.partOfSpeechTags.first, !partOfSpeechBlackList.contains(posTag) else {
                print("🏴‍☠️ Skipped line: '\(line)', due to POS tag being blacklisted")
                continue
            }

            if uniqueOrderedListOfLines.contains(line) {
                uniqueOrderedListOfLines[line]!.update(with: line)
            } else {
                uniqueOrderedListOfLines.append(line)
            }
        }

        return TaggedWords(lines: uniqueOrderedListOfLines, result: .allSpecifiedLinesWasParsed)
    }

    func parse(line: UnparsedReadLine) throws -> Line? {
        try Line(unparsedReadLine: line)
    }

    /// Saves the word list with the given name in the working directory and returns the `URL` to it
    func saveWordList(_ wordList: TaggedWords, outputFileName: String) throws -> String {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        let jsonData = try jsonEncoder.encode(wordList)
        return try save(data: jsonData, outputFileName: outputFileName)
    }

    @discardableResult
    func save(strings: [String], outputFileName: String) throws -> String {

        let stringsAsString = strings.joined(separator: "\n")
        guard let data = stringsAsString.data(using: .utf8) else {
            fatalError("Failed to create data from strings")
        }

        return try save(data: data, outputFileName: outputFileName)
    }

    func save(data: Data, outputFileName: String) throws -> String {
        let currentDirectoryPath = FileManager.default.currentDirectoryPath
        let path = currentDirectoryPath.appending("/\(outputFileName)")

        guard FileManager.default.createFile(atPath: path, contents: data, attributes: nil) else {
            fatalError("failed to save")
        }
        return path
    }

    func openFile(named fileName: String) throws -> FileHandle {
        do {
            let path = URL(fileURLWithPath: fileName)
            return try FileHandle(forReadingFrom: path)
        }  catch {
            throw Error.failedToReadFile(atPath: fileName)
        }
    }

    func checkAgainstWhitelist(_ taggedWords: TaggedWords) {
        let curatedWhitelist = Set(WhitelistedWords.strings)
        let taggedWords = Set(taggedWords.linesOfTaggedWords.contents.map { $0.word.lowercasedWord })

        let intersection = curatedWhitelist.intersection(taggedWords)
        let notFound = curatedWhitelist.subtracting(taggedWords)

        print("⭐️ Found #\(intersection.count) words of the #\(curatedWhitelist.count) curated words in TaggedWords")
        if notFound.count > 0 {
            print("👎🏻 but these words did not make it:\n\(notFound)")
        }
    }
}

public extension CommandLineTool {
    enum Error: Swift.Error {
        case missingFileName
        case missingNumberOfLinesToRead
        case numberOfLinesToReadNotAnInteger
        case failedToReadFile(atPath: String)
        case expectedWordCount(of: Int, butGot: Int)
    }
}

