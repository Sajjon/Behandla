
import Foundation
import Core

public final class CommandLineTool {

    private let arguments: [String]

    public init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
    }
}

// MARK: - Run
public extension CommandLineTool {

    func run() throws {
        let creator = try BIP39.Creator(arguments: arguments)
        try creator.createWordList()
    }
}
