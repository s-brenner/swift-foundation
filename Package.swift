// swift-tools-version: 5.9

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "swift-foundation",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(name: "SBFoundation", targets: ["SBFoundation"]),
        .library(name: "SBFoundationMacros", targets: ["SBFoundationMacros"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax", from: "509.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-macro-testing", from: "0.2.0"),
        .package(url: "https://github.com/s-brenner/swift-standard-library", from: "0.0.0"),
    ],
    targets: [
        .target(
            name: "SBFoundation",
            dependencies: [
                "SBFoundationMacros",
                .product(name: "SBStandardLibrary", package: "swift-standard-library"),
            ]
        ),
        .testTarget(
            name: "SBFoundationTests",
            dependencies: ["SBFoundation"]
        ),
        .target(
          name: "SBFoundationMacros",
          dependencies: [
            "SBFoundationMacrosPlugin",
          ]
        ),
        .macro(
          name: "SBFoundationMacrosPlugin",
          dependencies: [
            .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
            .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
          ]
        ),
        .testTarget(
          name: "SBFoundationMacrosPluginTests",
          dependencies: [
            "SBFoundationMacrosPlugin",
            .product(name: "MacroTesting", package: "swift-macro-testing"),
          ]
        ),
    ]
)
