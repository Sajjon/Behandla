//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-11.
//

import Foundation

protocol RulesJob: CacheableJob where Input: LinesConvertible, Output: LinesConvertible {
    func output(fromInputLine: Input.Line) -> Output.Line
    var rulesMatcher: RulesMatcher { get }
}

extension RulesJob {
    typealias RulesMatcher = IncludeIf<Input.Line>
}

extension RulesJob where Output.Line: LineFromCorpusFromLine, Output.Line.FromLine == Input.Line {
    func output(fromInputLine: Input.Line) -> Output.Line {
        let inputLineIsFromLine: Output.Line.FromLine = fromInputLine
        return Output.Line.init(line: inputLineIsFromLine)
    }
}

extension RulesJob {

    func newWork(input lines: Input) throws -> Output {
        var outputLines = [Output.Line]()

        for line in lines {
            guard rulesMatcher.checkIfLineShouldBeIncluded(line: line) else {
                continue
            }
            let outputLine = self.output(fromInputLine: line)
            outputLines.append(outputLine)
        }
        return Output(outputLines)
    }
}
