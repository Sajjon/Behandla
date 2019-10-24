//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-10-24.
//

import Foundation

/// A manually curated list of words that we dont want to have.
internal enum BlacklistedWords {}
internal extension BlacklistedWords {
    static let strings: [String] = [
        // curse words
        "satan",
        "kuk", // cock
        "fitta", // pussy

        // General negative associations
        "aids",
    ]
}
