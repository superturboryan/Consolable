// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "Consolable",
    platforms: [
        .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13), .macOS(.v13)
    ],
    products: [
        .library(name: "Consolable", targets: ["Consolable"]),
    ],
    dependencies: [
        // IMPORTANT: This tag must match the Xcode/Swift toolchain.
        // For Xcode 16 / Swift 6.1, 600.x is correct. If you use Xcode 15, use 509.x.
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "601.0.1"),
    ],
    targets: [
        // Macro implementation target (compiler plugin). Not exposed as a product.
        .macro(
            name: "Macros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),

        // Library target that declares the @Consolable macro and
        // depends on the implementation target above.
        .target(
            name: "Consolable",
            dependencies: ["Macros"]
        ),
    ]
)
