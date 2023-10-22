// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "swift-foundation",
    products: [
        .library(name: "SBFoundation", targets: ["SBFoundation"]),
    ],
    dependencies: [
        .package(url: "https://github.com/s-brenner/swift-standard-library", from: "0.0.0"),
    ],
    targets: [
        .target(
            name: "SBFoundation",
            dependencies: [
                .product(name: "SBStandardLibrary", package: "swift-standard-library"),
            ]
        ),
        .testTarget(name: "SBFoundationTests", dependencies: ["SBFoundation"]),
    ]
)
