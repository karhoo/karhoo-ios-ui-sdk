// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KarhooUISDK",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13),
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
//        .package(name: "KarhooSDK", url: "https://github.com/karhoo/karhoo-ios-sdk", .exact(Version(1, 6, 3))),
        .package(url: "https://github.com/karhoo/karhoo-ios-sdk", exact: "1.6.3"),
//        .package(name: "Adyen", url: "https://github.com/Adyen/adyen-ios", .exact(Version(4, 7, 1))),
        .package(url: "https://github.com/Adyen/adyen-ios", exact: "4.7.1"),
//        .package(name: "BraintreeDropIn", url: "https://github.com/braintree/braintree-ios-drop-in", .exact(Version(9, 3, 0))),
        .package(url: "https://github.com/braintree/braintree-ios-drop-in", exact: "9.3.0"),
//        .package(name: "PhoneNumberKit", url: "https://github.com/marmelroy/PhoneNumberKit", .exact(Version(3, 3, 1))),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", exact: "3.3.1"),
//        .package(name: "Braintree", url: "https://github.com/braintree/braintree_ios", .exact(Version(5, 6, 3)))
        .package(url: "https://github.com/braintree/braintree_ios", exact: "5.6.3")
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


        .testTarget(
            name: "KarhooUISDKTests",
            dependencies: [
                .target(name: "KarhooUISDK"),
                .target(name: "KarhooUISDKAdyen"),
                .target(name: "KarhooUISDKBraintree")
            ],
            path: "KarhooUISDKTests",
            exclude: ["Info.plist"])
    ]
)
