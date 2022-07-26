//
//  EnumGen.swift
//  WebComposeTest
//
//  Created by Ryu on 2022/07/24.
//

import Foundation

open class EnumGen {
    
    public enum EnumGenError: LocalizedError {
        case invalidName
        case failedToCreateFile
        case invalidFilePath
        
        public var errorDescription: String? {
            switch self {
            case .invalidName:
                return "enumName must be a string of one or more characters."
            case .failedToCreateFile:
                return "Failed to create file"
            case .invalidFilePath:
                return "The file path must indicate a file not a directory."
            }
        }
    }
    
    private let reservedWords = [
        "actor",
        "async",
        "async",
        "await",
        "class",
        "deinit",
        "enum",
        "extension",
        "fileprivate",
        "func",
        "import",
        "init",
        "inout",
        "internal",
        "let",
        "open",
        "operator",
        "precedencegroup",
        "private",
        "protocol",
        "public",
        "static",
        "some",
        "struct",
        "subscript",
        "typealias",
        "associatedtype",
        "var",
        "break",
        "case",
        "continue",
        "default",
        "defer",
        "do",
        "else",
        "fallthrough",
        "for",
        "guard",
        "if",
        "in",
        "repeat",
        "return",
        "switch",
        "where",
        "while",
        "as",
        "any",
        "Any",
        "catch",
        "false",
        "is",
        "nil",
        "rethrows",
        "super",
        "self",
        "Self",
        "throw",
        "throws",
        "true",
        "try",
        "#available",
        "#unavailable",
        "#colorLiteral",
        "#column",
        "#if",
        "#else",
        "#elseif",
        "#endif",
        "#error",
        "#file",
        "#fileID",
        "#filePath",
        "#fileLiteral",
        "#function",
        "#imageLiteral",
        "#keyPath",
        "#line",
        "#selector",
        "#sourceLocation",
        "#warning",
        "#dsohandle",
        "assignment",
        "associativity",
        "convenience",
        "dynamic",
        "didSet",
        "final",
        "get",
        "protocol",
        "infix",
        "indirect",
        "lazy",
        "left",
        "mutating",
        "none",
        "nonisolated",
        "nonmutating",
        "optional",
        "override",
        "postfix",
        "prefix",
        "Protocol",
        "required",
        "right",
        "set",
        "protocol",
        "Type",
        "unowned",
        "unowned(safe)",
        "unowned(unsafe)",
        "weak",
        "willSet"
    ]
    
    public private(set) var strings: [String]?
    public private(set) var associate: [(String, String)]?
    public let enumName: String
    public let fileURL: URL
    public let enumType: String?
    
    public init(strings: [String], enumName: String, enumType: String? = nil, path: String = #file) throws {
        guard enumName != "" else { throw EnumGenError.invalidName }
        
        self.strings = strings
        self.enumName = enumName
        self.enumType = enumType

        let originalPath = URL(fileURLWithPath: path)
        let directoryPath = originalPath.isDirectory ? originalPath : originalPath.deletingLastPathComponent()
        self.fileURL = directoryPath
            .appendingPathComponent(enumName, isDirectory: false)
            .appendingPathExtension("swift")
    }
    
    public init(associate: [(String, String)], enumName: String, enumType: String, path: String = #file) throws {
        guard enumName != "" else { throw EnumGenError.invalidName }
        
        self.associate = associate
        self.enumName = enumName
        self.enumType = enumType

        let originalPath = URL(fileURLWithPath: path)
        let directoryPath = originalPath.isDirectory ? originalPath : originalPath.deletingLastPathComponent()
        self.fileURL = directoryPath
            .appendingPathComponent(enumName, isDirectory: false)
            .appendingPathExtension("swift")
    }
    
    open func generate() throws {
        let enumString = createEnumString()
        
        if FileManager.default.createFile(atPath: fileURL.path, contents: enumString.data(using: .utf8)) {
            print("Creation of \(enumName) in \(fileURL.path) is completed")
        }
        else {
            throw EnumGenError.failedToCreateFile
        }
    }
    
    private func createEnumString() -> String {
        var enumString = ""
        let enumHeader =
        """
        // This is a generated file.
        // Generated by EnumGen, see https://github.com/Ryu0118/EnumGen
        """
        let importString = "import Foundation"
        var enumDefinition: String
        
        if let type = enumType {
            enumDefinition = "enum \(enumName): \(type) {"
        }
        else {
            enumDefinition = "enum \(enumName) {"
        }
        
        enumString.addLine(enumHeader, newLineCount: 0)
        enumString.addLine(importString, newLineCount: 2)
        enumString.addLine(enumDefinition, newLineCount: 2)
        
        strings?.forEach {
            if reservedWords.contains($0) {
                enumString.addLine("case `\($0)`", indentCount: 1)
            }
            else {
                enumString.addLine("case \($0)", indentCount: 1)
            }
        }
        
        associate?.forEach {
            if reservedWords.contains($0) {
                enumString.addLine("case `\($0)` = \"\($1)\"", indentCount: 1)
            }
            else {
                enumString.addLine("case \($0) = \"\($1)\"", indentCount: 1)
            }
        }
        
        enumString.addLine("}")
        
        return enumString
    }
    
}
