// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-openapi-security-schemes",
    platforms: [.macOS(.v11), .iOS(.v14), .tvOS(.v14), .watchOS(.v7), .visionOS(.v1)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "swift-openapi-security-schemes",
            targets: ["swift-openapi-security-schemes"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "swift-openapi-security-schemes"
        ),
        .testTarget(
            name: "swift-openapi-security-schemesTests",
            dependencies: ["swift-openapi-security-schemes"]
        ),
    ]
)
