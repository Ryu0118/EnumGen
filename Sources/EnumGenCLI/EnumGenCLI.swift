//
//  EnumGenCLI.swift
//  WebComposeTest
//
//  Created by Ryu on 2022/07/24.
//
#if os(macOS) || os(Linux)
import Foundation
import EnumGen
import ArgumentParser

@main
struct Enumgen: ParsableCommand {
    
    @Option(name: .shortAndLong, help: "Separator to convert text files to enum cases")
    var separator: String?
    
    @Option(name: .shortAndLong, help: "Name of enum type")
    var enumName: String?
    
    @Option(name: .shortAndLong, help: "If you want to recognize invalid_name as a case of enum, you can convert it to lower camel case by setting the value of the —delimiter option to \"_\" (like case invalidName)")
    var delimiter: String?
    
    @Flag(help: "Assign a value to each element")
    var associate = true
    
    @Argument(help: "The path (relative or absolute) of the file you want to convert to enum")
    var path: String

    mutating func run() throws {
        let currentDirectory = FileManager.default.currentDirectoryPath
        if path.hasPrefix("./"){ // relative path
            path.removeFirst(2)
            let url = URL(fileURLWithPath: currentDirectory).appendingPathComponent(path)
            try createEnumFile(url: url)
        }
        else if path.hasPrefix("/") { // absolute path
            let url = URL(fileURLWithPath: path)
            guard !url.isDirectory else { throw EnumGen.EnumGenError.invalidFilePath }
            try createEnumFile(url: url)
        }
        else { // relative path
            let url = URL(fileURLWithPath: currentDirectory).appendingPathComponent(path)
            try createEnumFile(url: url)
        }
    }
    
    private func createEnumFile(url: URL ) throws {
        let currentDirectory = FileManager.default.currentDirectoryPath
        let enumName = (enumName?.isEmpty ?? true) ? url.lastPathComponent : enumName ?? ""
        let separator = (separator?.isEmpty ?? true) ? "\n" : separator ?? "\n"
        
        guard let original = String(data: try Data(contentsOf: url), encoding: .utf8)?.components(separatedBy: separator) else { throw EnumGen.EnumGenError.invalidFilePath }
        
        if let delimiter = delimiter {
            let associate = removeDelimiterAndChangeToLowerCamel(original, delimiter: delimiter)
            if self.associate {
                let enumGen = try EnumGen(associate: Array(zip(associate, original)), enumName: enumName, enumType: String.self, path: currentDirectory)
                try enumGen.generate()
            }
            else {
                let enumGen = try EnumGen(strings: associate, enumName: enumName, path: currentDirectory)
                try enumGen.generate()
            }
        }
        else {
            let enumGen = try EnumGen(strings: original, enumName: enumName, path: currentDirectory)
            try enumGen.generate()
        }
    }
    
    private func removeDelimiterAndChangeToLowerCamel(_ strings: [String], delimiter: String) -> [String] {
        return strings.map { caseName -> String in
            guard caseName.contains(delimiter) else { return caseName }
            return caseName.components(separatedBy: delimiter).enumerated().map { index, string -> String in
                guard index != 0 else { return string }
                let lowercase = string.lowercased()
                let initial = string.prefix(1).uppercased()
                let dropped = lowercase.dropFirst()
                return initial + dropped
            }
            .joined()
        }
    }
    
}
#endif
