//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

/// Lines which have been elected for confirmation.
typealias HomonymLines = Lines<HomonymLine>

extension Lines: CustomStringConvertible where Line == HomonymLine {}
extension Lines where Line == HomonymLine {
    var description: String {
        lines.map {
            [String?]([
                "🏅 \($0.rank.pad(minLength: 8).yellow)",
                $0.wordForm.pad().green.bold.italic,
                $0.lemgrams.description.cyan,
                $0.homonym.map { "🎭#\($0.count)" }
            ]).compactMap{$0}.joined(separator: "\t")
        }.joined(separator: "\n")
    }
}
