//
//  UnparsedReadLine.swift
//  
//
//  Created by Alexander Cyon on 2019-10-23.
//

import Foundation

public struct UnparsedReadLine: CustomStringConvertible {
    public let unparsedLine: String
    public let positionInCorpus: Int
}

// MARK: CustomStringConvertible
public extension UnparsedReadLine {
    var description: String { unparsedLine }
}
