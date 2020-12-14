// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "Tiny",
    platforms: [
        .macOS(.v10_10)
    ],
    products: [
        .library(name: "Tiny", targets: ["Tiny"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Nimble.git", from: "9.0.0"),
        .package(url: "https://github.com/Quick/Quick.git", from: "3.0.0"),
    ],
    targets: [
        .target(name: "Tiny", path: "source", exclude: ["Test"]),
        .testTarget(name: "Tiny-Test", dependencies: ["Tiny", "Quick", "Nimble"], path: "source/Test"),
    ],
    swiftLanguageVersions: [.v5]
)
