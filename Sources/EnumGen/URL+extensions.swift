//
//  URL+extensions.swift
//  WebComposeTest
//
//  Created by Ryu on 2022/07/24.
//

import Foundation

public extension URL {
    var isDirectory: Bool {
       (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}
