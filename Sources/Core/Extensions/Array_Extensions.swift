//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-07.
//

import Foundation

extension Array where Element: Hashable {
    func removingDuplicates() -> Self {
        return [Element](Set<Element>(self))
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
