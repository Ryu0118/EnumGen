// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EnumGen",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_11),
        .tvOS(.v9),
        .watchOS(.v2),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "EnumGen",
            targets: ["EnumGen"]),
        .executable(name: "EnumGenCLI",
                    targets: ["EnumGenCLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.3")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "EnumGen",
            dependencies: []),
        
        .executableTarget(name: "EnumGenCLI",
                          dependencies: ["EnumGen", .product(name: "ArgumentParser", package: "swift-argument-parser")]),
        .testTarget(
            name: "EnumGenTests",
            dependencies: ["EnumGen"]),
    ]
)
