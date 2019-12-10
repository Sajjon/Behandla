//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

protocol NamedTask {
    var name: String { get }
}

extension NamedTask {
    var name: String {
        .init(describing: Mirror(reflecting: self).subjectType)
    }
}

protocol Job: NamedTask {
    associatedtype Input
    associatedtype Output
    func work(input: Input) throws -> Output
}
