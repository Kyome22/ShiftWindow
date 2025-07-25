// swift-tools-version: 6.1

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ExistentialAny"),
]

let package = Package(
    name: "LocalPackage",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "DataSource",
            targets: ["DataSource"]
        ),
        .library(
            name: "Model",
            targets: ["Model"]
        ),
        .library(
            name: "UserInterface",
            targets: ["UserInterface"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", exact: "1.6.2"),
        .package(url: "https://github.com/Kyome22/SpiceKey.git", exact: "6.0.1"),
        .package(url: "https://github.com/Kyome22/WindowSceneKit.git", exact: "1.1.0"),
        .package(url: "https://github.com/sparkle-project/Sparkle.git", exact: "2.6.4"),
    ],
    targets: [
        .target(
            name: "DataSource",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Sparkle", package: "Sparkle"),
                .product(name: "SpiceKey", package: "SpiceKey"),
                .product(name: "WindowSceneKit", package: "WindowSceneKit"),
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "Model",
            dependencies: [
                "DataSource",
                .product(name: "Logging", package: "swift-log"),
                .product(name: "SpiceKey", package: "SpiceKey"),
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "UserInterface",
            dependencies: [
                "DataSource",
                "Model",
                .product(name: "SpiceKey", package: "SpiceKey"),
                .product(name: "WindowSceneKit", package: "WindowSceneKit"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "ModelTests",
            dependencies: [
                "DataSource",
                "Model",
            ],
            swiftSettings: swiftSettings
        ),
    ]
)
