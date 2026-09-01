// swift-tools-version: 6.2
import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "swift-foundation",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macCatalyst(.v13)
    ],
    products: [
        .library(name: "SBFoundation", targets: ["SBFoundation"]),
        .library(name: "SBFoundationMacros", targets: ["SBFoundationMacros"]),
        .library(name: "SBFoundationTimeZones", targets: ["SBFoundationTimeZones"]),
    ],
    traits: [
        .trait(name: "Algorithms", description: "Import the Algorithms library"),
        .trait(name: "IssueReporting", description: "Import the IssueReporting library"),
        .trait(name: "Tagged", description: "Import the Tagged library"),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-issue-reporting", from: "2.0.0"),
//        .package(url: "https://github.com/pointfreeco/swift-macro-testing", from: "0.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-tagged", from: "0.0.0"),
        .package(
            url: "https://github.com/s-brenner/swift-standard-library",
            from: "0.15.0",
            traits: [
                .trait(name: "Algorithms", condition: .when(traits: ["Algorithms"])),
            ]
        ),
        .package(url: "https://github.com/swiftlang/swift-syntax", "509.0.0"..<"605.0.0"),
    ],
    targets: [
        .target(
            name: "SBFoundation",
            dependencies: [
                .product(
                    name: "IssueReporting",
                    package: "swift-issue-reporting",
                    condition: .when(traits: ["IssueReporting"])
                ),
                .product(name: "SBStandardLibrary", package: "swift-standard-library"),
                .product(
                    name: "Tagged",
                    package: "swift-tagged",
                    condition: .when(traits: ["Tagged"])
                ),
            ]
        ),
        .testTarget(
            name: "SBFoundationTests",
            dependencies: [
                "SBFoundation",
            ]
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
            .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
          ]
        ),
        .testTarget(
          name: "SBFoundationMacrosPluginTests",
          dependencies: [
//            .product(name: "MacroTesting", package: "swift-macro-testing"),
            "SBFoundationMacrosPlugin",
          ]
        ),
        .target(
            name: "SBFoundationTimeZones",
            dependencies: [
                "SBFoundation",
                "SBFoundationMacros",
            ]
        ),
        .testTarget(
            name: "SBFoundationTimeZonesTests",
            dependencies: [
                "SBFoundationTimeZones",
            ]
        ),
    ]
)
