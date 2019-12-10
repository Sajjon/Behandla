//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

protocol Job {
    associatedtype Input
    associatedtype Output

    func work(input: Input) throws -> Output
}
