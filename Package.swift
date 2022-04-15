// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KarhooUISDK",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v12),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "KarhooUISDK",
            targets: ["KarhooUISDK"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "KarhooSDK", url: "https://github.com/karhoo/karhoo-ios-sdk", .branch("MOB-4020-release-1.6")),
        .package(name: "Adyen", url: "https://github.com/Adyen/adyen-ios", .exact(Version(4, 7, 1))),
        .package(name: "FloatingPanel", url: "https://github.com/scenee/FloatingPanel", .exact(Version(2, 0, 1))),
        .package(name: "BraintreeDropIn", url: "https://github.com/braintree/braintree-ios-drop-in", .exact(Version(9, 3, 0))),
        .package(name: "PhoneNumberKit", url: "https://github.com/marmelroy/PhoneNumberKit", .exact(Version(3, 3, 0))),
        .package(name: "Braintree", url: "https://github.com/braintree/braintree_ios", .exact(Version(5, 5, 0)))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "KarhooUISDK",
            dependencies: [.product(name: "KarhooSDK", package: "KarhooSDK"),
                           .product(name: "Adyen", package: "Adyen"),
                           .product(name: "AdyenDropIn", package: "Adyen"),
                           .product(name: "FloatingPanel", package: "FloatingPanel"),
                           .product(name: "BraintreeDropIn", package: "BraintreeDropIn"),
                           .product(name: "PhoneNumberKit", package: "PhoneNumberKit"),
                           .product(name: "BraintreePaymentFlow", package: "Braintree"),
                           .product(name: "BraintreeThreeDSecure", package: "Braintree")],
            path: "KarhooUISDK",
            exclude: ["Extensions/Bundle+extensions/Bundle+current.swift", "Info.plist"]),
        .testTarget(
            name: "KarhooUISDKTests",
            dependencies: [.target(name: "KarhooUISDK")],
            path: "KarhooUISDKTests",
            exclude: ["Info.plist"])
    ]
)
