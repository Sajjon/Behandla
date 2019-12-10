//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

struct Cacher {
    let basePath: String
    init(basePath: String = "Assets/Output/Intermediate") {
        self.basePath = basePath
    }
}

extension Cacher {
    static let currentDirectoryPath = Self(basePath: FileManager.default.currentDirectoryPath)
}

extension Cacher {

    /// Saves the codable `model` with the given `name` in the working directory and returns the `URL` to it
    @discardableResult
    func save<C>(_ model: C, name: String) throws -> String where C: Codable {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        let jsonData = try jsonEncoder.encode(model)

        return try save(data: jsonData, outputFileName: "\(basePath)/\(name)")
    }

    @discardableResult
    func save(strings: [String], outputFileName: String) throws -> String {

        let stringsAsString = strings.joined(separator: "\n")
        guard let data = stringsAsString.data(using: .utf8) else {
            fatalError("Failed to create data from strings")
        }

        return try save(data: data, outputFileName: outputFileName)
    }

    func save(data: Data, outputFileName: String) throws -> String {
        let currentDirectoryPath = FileManager.default.currentDirectoryPath
        let path = currentDirectoryPath.appending("/\(outputFileName)")

        guard FileManager.default.createFile(atPath: path, contents: data, attributes: nil) else {
            fatalError("failed to save")
        }
        return path
    }

    func load<C>(name fileName: String) throws -> C? where C: Codable {
        let file = try openFile(named: fileName)
        let contentsOfFile = file.readDataToEndOfFile()
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(C.self, from: contentsOfFile)
    }

    func openFile(named fileName: String) throws -> FileHandle {
          let fileUrlPath = "\(basePath)/\(fileName)"
        do {
            let path = URL(fileURLWithPath: fileUrlPath)
            return try FileHandle(forReadingFrom: path)
        }  catch {
            print("⚠️ FileHandle.Error: \(error)")
            throw Error.failedToReadFile(atPath: fileName)
        }
    }
}

extension Cacher {
    enum Error: Swift.Error {
        case failedToReadFile(atPath: String)
    }
}
