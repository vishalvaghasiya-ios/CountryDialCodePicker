// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CountryDialCodePicker",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "CountryDialCodePicker",
            targets: ["CountryDialCodePicker"]
        ),
    ],
    targets: [
        .target(
            name: "CountryDialCodePicker",
            resources: [
                .process("Data/countries.json"),
                .process("Assets/Flags")
            ]
        ),
    ]
)
