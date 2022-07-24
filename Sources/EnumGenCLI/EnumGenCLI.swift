//
//  EnumGenCLI.swift
//  WebComposeTest
//
//  Created by Ryu on 2022/07/24.
//

import Foundation
import EnumGen
import ArgumentParser

@main
struct Enumgen: ParsableCommand {
    
    @Option(name: .shortAndLong, help: "Separator to convert text files to enum cases")
    var separator: String?
    
    @Option(name: .shortAndLong, help: "Name of enum type")
    var enumName: String?
    
    @Argument(help: "The path (relative or absolute) of the file you want to convert to enum")
    var path: String

    mutating func run() throws {
        let currentDirectory = FileManager.default.currentDirectoryPath
        if path.prefix(2) == "./" {
            path.removeFirst(2)
            let url = URL(fileURLWithPath: currentDirectory).appendingPathComponent(path)
            try createEnumFile(url: url)
        }
        else if path.prefix(1) == "/" {
            let url = URL(fileURLWithPath: path)
            guard !url.isDirectory else { throw EnumGen.EnumGenError.invalidFilePath }
            try createEnumFile(url: url)
        }
        else {
            let url = URL(fileURLWithPath: currentDirectory).appendingPathComponent(path)
            try createEnumFile(url: url)
        }
    }
    
    private func createEnumFile(url: URL ) throws {
        let currentDirectory = FileManager.default.currentDirectoryPath
        let enumName = (enumName?.isEmpty ?? true) ? url.lastPathComponent : enumName ?? ""
        let separator = (separator?.isEmpty ?? true) ? "\n" : separator ?? "\n"
        
        guard let original = String(data: try Data(contentsOf: url), encoding: .utf8)?.components(separatedBy: separator) else { throw EnumGen.EnumGenError.invalidFilePath }
        
        let associate = original.map { caseName -> String in
            guard caseName.contains(".") else { return caseName }
            return caseName.components(separatedBy: ".").enumerated().map { index, string -> String in
                guard index != 0 else { return string }
                let lowercase = string.lowercased()
                let initial = string.prefix(1).uppercased()
                let dropped = lowercase.dropFirst()
                return initial + dropped
            }
            .joined()
        }
        
        if associate != original {
            let enumGen = try EnumGen(associate: Array(zip(associate, original)), enumName: enumName, enumType: String.self, path: currentDirectory)
            try enumGen.generate()
        }
        else {
            let enumGen = try EnumGen(strings: original, enumName: enumName, path: currentDirectory)
            try enumGen.generate()
        }
    }
    
}
