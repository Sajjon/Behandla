
import Foundation
import Core

final class CommandLineTool {

    private let arguments: [String]

    init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
    }
}

// MARK: - Run
extension CommandLineTool {

    func run() throws {
        let creator = try BIP39.Creator(arguments: arguments)
        try creator.createWordList()
    }
}
