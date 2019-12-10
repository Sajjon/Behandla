//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-08.
//

import Foundation

extension String {
    func parts(separatedBy delimiter: Character) -> [String] {
        split(separator: delimiter).map { String($0) }
    }
}
