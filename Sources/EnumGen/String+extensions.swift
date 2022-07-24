//
//  String+extensions.swift
//  WebComposeTest
//
//  Created by Ryu on 2022/07/24.
//

import Foundation

extension String {
    
    mutating func indent(_ count: Int) {
        if let _ = self.components(separatedBy: "\n").last {
            self += "\n" + String(repeating: "    ", count: count)
        }
        else {
            self += String(repeating: "    ", count: count)
        }
    }
    
    mutating func newLine() {
        self += "\n"
    }
    
    mutating func addLine(_ string: String, indentCount: Int = 0) {
        self += "\n" + String(repeating: "    ", count: indentCount) + string
    }
    
}
