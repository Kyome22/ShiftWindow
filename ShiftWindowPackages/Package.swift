// swift-tools-version: 6.0

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ExistentialAny"),
]

let package = Package(
    name: "ShiftWindowPackages",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "DataLayer",
            targets: ["DataLayer"]
        ),
        .library(
            name: "Domain",
            targets: ["Domain"]
        ),
        .library(
            name: "Presentation",
            targets: ["Presentation"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", exact: "1.6.1"),
        .package(url: "https://github.com/Kyome22/PanelSceneKit.git", exact: "1.2.0"),
        .package(url: "https://github.com/Kyome22/SpiceKey.git", exact: "5.4.1"),
    ],
    targets: [
        .target(
            name: "DataLayer",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "SpiceKey", package: "SpiceKey"),
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "Domain",
            dependencies: [
                "DataLayer",
                .product(name: "Logging", package: "swift-log"),
                .product(name: "PanelSceneKit", package: "PanelSceneKit"),
                .product(name: "SpiceKey", package: "SpiceKey"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "DomainTests",
            dependencies: ["Domain"],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "Presentation",
            dependencies: [
                "Domain",
                .product(name: "PanelSceneKit", package: "PanelSceneKit"),
                .product(name: "SpiceKey", package: "SpiceKey"),
            ],
            swiftSettings: swiftSettings
        ),
    ]
)
