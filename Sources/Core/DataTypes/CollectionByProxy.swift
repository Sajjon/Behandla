//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

protocol CollectionByProxy:
    RandomAccessCollection
where
    Index == Int
{
    var contents: [Element] { get }
}


// MARK: Collection
extension CollectionByProxy {

    var startIndex: Index { contents.startIndex }
    var endIndex: Index { contents.endIndex }

    subscript(index: Index) -> Element { contents[index] }

    func index(after index: Index) -> Index {
        contents.index(after: index)
    }
}

//extension CollectionByProxy where Element: CustomStringConvertible {
//    var description: String {
//        String(describing: contents)
//    }
//}
