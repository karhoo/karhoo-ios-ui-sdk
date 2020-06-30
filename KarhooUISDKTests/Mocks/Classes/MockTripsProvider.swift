//
//  MockTripsProvider.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK
@testable import KarhooUISDK

final class MockTripsProvider: TripsProvider {

    var startCalled = false
    func start() {
        startCalled = true
    }

    var stopCalled = false
    func stop() {
        stopCalled = true
    }

    var delegate: TripsProviderDelegate? //swiftlint:disable:this weak_delegate

    var theTripsToFetch: [TripInfo] = []
    func fetched(trips: [TripInfo]) {
        theTripsToFetch = trips
    }

    var theErrorToSet: Error?
    func tripProviderFailed(error: Error?) {
        theErrorToSet = error
    }
    
    var testPage: Int = 0
    func requestNewPage(pageOffset: Int) {
        testPage = pageOffset
    }
}
