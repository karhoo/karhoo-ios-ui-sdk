//
//  MockTripsProvider.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK
@testable import KarhooUISDK

final public class MockTripsProvider: TripsProvider {

    public var startCalled = false
    public func start() {
        startCalled = true
    }

    public var stopCalled = false
    public func stop() {
        stopCalled = true
    }

    public var delegate: TripsProviderDelegate? // swiftlint:disable:this weak_delegate

    public var theTripsToFetch: [TripInfo] = []
    public func fetched(trips: [TripInfo]) {
        theTripsToFetch = trips
    }

    public var theErrorToSet: Error?
    public func tripProviderFailed(error: Error?) {
        theErrorToSet = error
    }
    
    public var testPage: Int = 0
    public func requestNewPage(pageOffset: Int) {
        testPage = pageOffset
    }
}
