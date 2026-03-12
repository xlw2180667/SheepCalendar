// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SheepCalendar",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "SheepCalendar",
            targets: ["SheepCalendar"]
        ),
    ],
    targets: [
        .target(
            name: "SheepCalendar"
        ),
        .testTarget(
            name: "SheepCalendarTests",
            dependencies: ["SheepCalendar"]
        ),
    ]
)
