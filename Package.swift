// swift-tools-version: 5.5

import PackageDescription

let package = Package(
  name: "ToastUI",
  platforms: [
    .iOS(.v15),
    .macOS(.v12),
    .tvOS(.v15),
    .watchOS(.v8),
  ],
  products: [
    .library(
      name: "ToastUI",
      targets: ["ToastUI"])
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swiftui-navigation", from: "0.1.0")
  ],
  targets: [
    .target(
      name: "ToastUI",
      dependencies: [
        .product(name: "SwiftUINavigation", package: "swiftui-navigation")
      ]),
    .testTarget(
      name: "ToastUITests",
      dependencies: ["ToastUI"]),
  ]
)
