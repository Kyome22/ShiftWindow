// swift-tools-version: 6.1

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ExistentialAny"),
]

let package = Package(
    name: "ShiftWindowPackages",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "Infrastructure",
            targets: ["Infrastructure"]
        ),
        .library(
            name: "Model",
            targets: ["Model"]
        ),
        .library(
            name: "Presentation",
            targets: ["Presentation"]
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
            name: "Infrastructure",
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
                "Infrastructure",
                .product(name: "Logging", package: "swift-log"),
                .product(name: "SpiceKey", package: "SpiceKey"),
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "Presentation",
            dependencies: [
                "Infrastructure",
                "Model",
                .product(name: "SpiceKey", package: "SpiceKey"),
                .product(name: "WindowSceneKit", package: "WindowSceneKit"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "ModelTests",
            dependencies: [
                "Infrastructure",
                "Model",
            ],
            swiftSettings: swiftSettings
        ),
    ]
)
