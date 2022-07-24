//
//  String+extensions.swift
//  WebComposeTest
//
//  Created by Ryu on 2022/07/24.
//

import Foundation

extension String {

    mutating func newLine() {
        self += "\n"
    }
    
    mutating func addLine(_ string: String, newLineCount: Int = 1, indentCount: Int = 0) {
        self += String(repeating: "\n", count: newLineCount) + String(repeating: "    ", count: indentCount) + string
    }
    
}
