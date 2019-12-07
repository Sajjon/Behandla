//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-07.
//

import Foundation

internal func castErrorOrKill<Error>(_ anyError: Swift.Error) -> Error where Error: Swift.Error {
    guard let error = anyError as? Error else {
        fatalError("Wrong error type, got error: \(anyError), but expected error of type: \(type(of: Error.self))")
    }
    return error
}
