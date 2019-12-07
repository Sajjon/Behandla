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
