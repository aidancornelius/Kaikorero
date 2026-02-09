//
//  Package.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Kaikorero",
    platforms: [
        .iOS(.v26),
        .macOS(.v15),
    ],
    products: [
        .library(
            name: "Kaikorero",
            targets: ["Kaikorero"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/4rays/swift-fsrs", from: "0.9.2"),
    ],
    targets: [
        .target(
            name: "Kaikorero",
            dependencies: [
                .product(name: "SwiftFSRS", package: "swift-fsrs"),
            ],
            path: "Kaikorero",
            exclude: ["App/KaikoreroApp.swift"],
            resources: [
                .process("Resources/Data"),
                .copy("Resources/Audio"),
            ]
        ),
        .testTarget(
            name: "KaikoreroTests",
            dependencies: ["Kaikorero"],
            path: "KaikoreroTests"
        ),
    ]
)
