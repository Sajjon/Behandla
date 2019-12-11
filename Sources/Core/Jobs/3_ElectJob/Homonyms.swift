//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-11.
//

import Foundation

// MARK: Homonyms
final class Homonyms: CustomStringConvertible {

    /// Homonyms by count
    lazy var byCount: [Int: [Homonym]] = {
        var byCount = [Int: [Homonym]]()
        for homonym in homonyms {
            var listOfHomonymsByCount = byCount[homonym.count] ?? []
            listOfHomonymsByCount.append(homonym)
            byCount[homonym.count] = listOfHomonymsByCount
        }
        return byCount
    }()

    /// Homonyms by word
    lazy var forWord: [WordForm: Homonym] = {
        var forWord = [WordForm: Homonym]()
        for homonym in homonyms {
            forWord[homonym.wordForm] = homonym
        }
        return forWord
    }()

    private let homonyms: OrderedSet<Homonym>

    init(_ homonyms: OrderedSet<Homonym>) {
        self.homonyms = homonyms
    }
}

extension Homonyms {
    var count: Int { homonyms.count }
}

// MARK: CustomStringConvertible
extension Homonyms {
    var description: String {

        var outputLines = ["🎭 Found #\(homonyms.count) homonyms, sorted by count:"]
        let homonymCountSorted = self.byCount.keys.sorted(by: { $0 > $1 })
        for homonymCount in homonymCountSorted {
            outputLines.append(".:*~*:._.:*~*:._.:*~*:   \(homonymCount)   :*~*:._.:*~*:._.:*~*:.".red.bold)
            self.byCount[homonymCount]!.forEach {
                outputLines.append(
                    [
                        "🎭 #\($0.count.pad(minLength: 4).yellow)",
                        $0.wordForm.pad().green.bold.italic,
                        $0.lemgrams.description.cyan,
                    ]
                        .joined(separator: "\t")
                )
            }
            outputLines.append("\n")
        }

        return outputLines.joined(separator: "\n")
    }
}
