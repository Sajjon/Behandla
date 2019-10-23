import XCTest
import class Foundation.Bundle

final class BehandlaTests: XCTestCase {

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
