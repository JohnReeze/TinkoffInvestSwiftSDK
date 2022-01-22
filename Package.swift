// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TinkoffInvestSDK",
    platforms: [
        // Add support for all platforms starting from a specific version.
        .macOS(.v10_15),
        .iOS(.v14),
        .watchOS(.v5),
        .tvOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "TinkoffInvestSDK",
            targets: ["TinkoffInvestSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.6.0"),
        .package(url: "https://github.com/vyshane/grpc-swift-combine.git", from: "1.0.8"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "TinkoffInvestSDK",
            dependencies: [
                .product(name: "GRPC", package: "grpc-swift"),
                .product(name: "CombineGRPC", package: "grpc-swift-combine")
            ]),
        .testTarget(
            name: "TinkoffInvestSDKTests",
            dependencies: ["TinkoffInvestSDK"]),
    ]
)
