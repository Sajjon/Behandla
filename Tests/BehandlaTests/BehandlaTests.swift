import XCTest
import class Foundation.Bundle
@testable import Core
@testable import Behandla

final class BehandlaTests: XCTestCase {


//    // made up word "noobar" and "noob" cannot both be in list, since they share the 4 first characters
//    func test_that_words_noob_and_noobar_cannot_both_be_in_list() {
//        let lines = Lines()
//
//        let noobar: Line = "noobar"
//        let noob: Line = "noob"
//        lines.insert(line: noob)
//        XCTAssertEqual(lines.count, 1)
//        XCTAssertEqual(lines.firstLineWithHash(matching: noob)!.numberOfOccurencesInCorpus, 1)
//        lines.insert(line: noobar)
//        XCTAssertEqual(lines.count, 1)
//        XCTAssertEqual(lines.firstLineWithHash(matching: noob)!.numberOfOccurencesInCorpus, 1)
//    }
//
//    func test_that_hash_of_words_noob_and_noobar_equal() {
//
//        let noobar: Line = "noobar"
//        let noob: Line = "noob"
//
//        XCTAssertEqual(noobar.hashValue, noob.hashValue)
//    }

    func testExample() throws {
        XCTAssert(true)

//        let fooBinary = productsDirectory.appendingPathComponent("Behandla")
//
//        let process = Process()
//        process.executableURL = fooBinary
////        process.arguments = ["../../smallCorpus", "100"]
//
//        let pipe = Pipe()
//        process.standardOutput = pipe
//
//        try process.run()
//        process.waitUntilExit()
//
//        let data = pipe.fileHandleForReading.readDataToEndOfFile()
//        let output = String(data: data, encoding: .utf8)
//
//        XCTAssertEqual(output, "wordlist.json")
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
