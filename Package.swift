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
        .library(
            name: "AdyenPSP",
            targets: ["AdyenPSP"]),
        .library(
            name: "BraintreePSP",
            targets: ["BraintreePSP"]),

    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "KarhooSDK", url: "https://github.com/karhoo/karhoo-ios-sdk", .exact(Version(1, 6, 1))),
        .package(name: "Adyen", url: "https://github.com/Adyen/adyen-ios", .exact(Version(4, 7, 1))),
        .package(name: "FloatingPanel", url: "https://github.com/scenee/FloatingPanel", .exact(Version(2, 0, 1))),
        .package(name: "BraintreeDropIn", url: "https://github.com/braintree/braintree-ios-drop-in", .exact(Version(9, 3, 0))),
        .package(name: "PhoneNumberKit", url: "https://github.com/marmelroy/PhoneNumberKit", .exact(Version(3, 3, 0))),
        .package(name: "Braintree", url: "https://github.com/braintree/braintree_ios", .exact(Version(5, 5, 0)))
    ],
    targets: [
        .target(
            name: "KarhooUISDK",
            dependencies: [.product(name: "KarhooSDK", package: "KarhooSDK"),
                           .product(name: "FloatingPanel", package: "FloatingPanel"),
                           .product(name: "PhoneNumberKit", package: "PhoneNumberKit")],
            path: "KarhooUISDK",
            exclude: ["Extensions/Bundle+extensions/Bundle+current.swift", "Info.plist"]),

        .target(
            name: "AdyenPSP",
            dependencies: [.target(name: "KarhooUISDK"),
                           .product(name: "Adyen", package: "Adyen"),
                           .product(name: "AdyenDropIn", package: "Adyen")],
            path: "AdyenPSP"),

        .target(
            name: "BraintreePSP",
            dependencies: [.target(name: "KarhooUISDK"),
                           .product(name: "BraintreeDropIn", package: "BraintreeDropIn"),
                           .product(name: "BraintreePaymentFlow", package: "Braintree"),
                           .product(name: "BraintreeThreeDSecure", package: "Braintree")],
            path: "BraintreePSP"),


        .testTarget(
            name: "KarhooUISDKTests",
            dependencies: [.target(name: "KarhooUISDK")],
            path: "KarhooUISDKTests",
            exclude: ["Info.plist"])
    ]
)
