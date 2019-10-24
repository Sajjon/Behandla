//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-10-24.
//

import Foundation

public final class Lines {
    public private(set) var lines: OrderedSet<Line>

    init(_ lines: OrderedSet<Line> = .init()) {
        self.lines = lines
    }

    convenience init(lines: Line...) {
        self.init(OrderedSet(array: lines))
    }
}

public extension Lines {

    func containsLine(equalTo line: Line) -> Bool {
        lines.contains(line) // using equality, not hash
    }

    /// Using hash value rather than equality to check if lines "match"
    func containsLineWithHash(matching line: Line) -> Bool {
        firstLineWithHash(matching: line) != nil
    }

    /// Using hash value rather than equality to check if lines "match"
    func firstLineWithHash(matching line: Line) -> Line? {
        lines.first(where: { $0.hashValue == line.hashValue })
    }

    enum LineWithSameHashButDifferentWordExistsStrategy {

        case skip(

            confirmSkip: ((_ existing: Line, _ skippedNew: Line) -> Void) = { existing, new in
//                print("⚠️ skipped adding line '\(new)', has same hash as existing: '\(existing)'")
            }
        )

        case replaceIf(
            condition: (_ existing: Line, _ new: Line) -> Bool
        )

    }

    func insert(
        line newLine: Line,
        existsStrategy: LineWithSameHashButDifferentWordExistsStrategy = .skip()
    ) {

        let updateOrAdd = { [unowned self] in
            // using equality, not hash as above
            if self.lines.contains(newLine) {
                self.lines[newLine]!.update(with: newLine)
            } else {
                self.lines.append(newLine)
            }
        }

        // using hash, not equality
        if let existingLine = firstLineWithHash(matching: newLine), newLine != existingLine {
            switch existsStrategy {
                case .skip(let confirmSkip): confirmSkip(existingLine, newLine)
                case .replaceIf(let replaceCondition):
                    if replaceCondition(existingLine, newLine) {
                        updateOrAdd()
                    }
            }
        } else {
            updateOrAdd()
        }

    }
}

public extension Lines {
    var count: Int {
        lines.count
    }
}
