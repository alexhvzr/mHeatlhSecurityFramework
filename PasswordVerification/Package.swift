// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "MyApp",
    dependencies: [
        .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "15.0.0")
    ],
    targets: [
        .target(
            name: "MyApp",
            dependencies: ["KeychainSwift"],
            path: "Sources")
    ]
)
