// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KarhooUISDK",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "KarhooUISDK",
            targets: ["KarhooUISDK"]),
        .library(
            name: "KarhooUISDKAdyen",
            targets: ["KarhooUISDKAdyen"]),
        .library(
            name: "KarhooUISDKBraintree",
            targets: ["KarhooUISDKBraintree"]),

    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
//        .package(url: "https://github.com/karhoo/karhoo-ios-sdk", branch: "master"),
        .package(url: "https://github.com/karhoo/karhoo-ios-sdk", exact: "1.8.0"),
        .package(url: "https://github.com/Adyen/adyen-ios", exact: "4.7.1"),
        .package(url: "https://github.com/braintree/braintree-ios-drop-in", exact: "9.8.0"),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", exact: "3.3.1"),
        .package(url: "https://github.com/braintree/braintree_ios", exact: "5.20.1"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", exact: "1.9.0"),
        .package(url: "https://github.com/Quick/Quick", exact: "5.0.1"),
        .package(url: "https://github.com/Quick/Nimble", exact: "10.0.0")
    ],
    targets: [
        .target(
            name: "KarhooUISDK",
            dependencies: [.product(name: "KarhooSDK", package: "karhoo-ios-sdk"),
                           .product(name: "PhoneNumberKit", package: "PhoneNumberKit")],
            path: "KarhooUISDK",
            exclude: ["Extensions/Bundle+extensions/Bundle+current.swift", "Info.plist"]),

        .target(
            name: "KarhooUISDKAdyen",
            dependencies: [.target(name: "KarhooUISDK"),
                           .product(name: "Adyen", package: "adyen-ios"),
                           .product(name: "AdyenDropIn", package: "adyen-ios")],
            path: "AdyenPSP"),

        .target(
            name: "KarhooUISDKBraintree",
            dependencies: [.target(name: "KarhooUISDK"),
                           .product(name: "BraintreeDropIn", package: "braintree-ios-drop-in"),
                           .product(name: "BraintreePaymentFlow", package: "braintree_ios"),
                           .product(name: "BraintreeThreeDSecure", package: "braintree_ios")],
            path: "BraintreePSP"),

        .target(
            name: "KarhooUISDKTestUtils",
            dependencies: [.target(name: "KarhooUISDK")],
            path: "KarhooUISDKTestUtils"),
        
        .testTarget(
            name: "KarhooUISDKTests",
            dependencies: [
                .target(name: "KarhooUISDKTestUtils"),
                .target(name: "KarhooUISDK"),
                .target(name: "KarhooUISDKAdyen"),
                .target(name: "KarhooUISDKBraintree"),
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
                .product(name: "Quick", package: "Quick"),
                .product(name: "Nimble", package: "Nimble")
                
            ],
            path: "KarhooUISDKTests"),
        
        .testTarget(
            name: "KarhooUISDKUITests",
            dependencies: [
                .target(name: "KarhooUISDKTestUtils"),
                .target(name: "KarhooUISDK"),
                .target(name: "KarhooUISDKAdyen"),
                .target(name: "KarhooUISDKBraintree"),
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
                .product(name: "Quick", package: "Quick"),
                .product(name: "Nimble", package: "Nimble")
                
            ],
            path: "KarhooUISDKUITests",
            exclude: [])
    ]
)
