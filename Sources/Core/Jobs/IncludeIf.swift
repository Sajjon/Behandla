//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-11.
//

import Foundation

// MARK: IncludeIf
struct IncludeIf<Line>: ExpressibleByArrayLiteral where Line: LineFromCorpusConvertible {
    let rules: [Rule]
    init(rules: [Rule]) {
        self.rules = rules
    }
    init(arrayLiteral rules: Rule...) {
        self.init(rules: rules)
    }
}


extension IncludeIf {
    func checkIfLineShouldBeIncluded(line: Line) -> Bool {
        rules.allSatisfy { $0.isLineGood(line) }
    }
}

// MARK: IncludeIf Rule
extension IncludeIf {
    struct Rule {
        typealias IncludeLineIf = (Line) -> Bool

        let nameOfRule: String
        private let includeLineIf: IncludeLineIf
        let isCompound: Bool
        init(name: String = #function, isCompound: Bool = false, includeLineIf: @escaping IncludeLineIf) {
            self.nameOfRule = name
            self.isCompound = isCompound
            self.includeLineIf = includeLineIf
        }
    }
}

extension IncludeIf.Rule {
    func isLineGood(_ line: Line) -> Bool {
        let included = includeLineIf(line)
        if !included && !isCompound {
            //            print("👎 \(nameOfRule): <\(line)>")
        }
        return included
    }
}
