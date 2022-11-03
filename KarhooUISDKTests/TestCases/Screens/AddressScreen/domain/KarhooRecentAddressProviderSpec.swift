//
//  KarhooRecentAddressProviderSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
import KarhooSDK
@testable import KarhooUISDKTestUtils
@testable import KarhooUISDK

class KarhooRecentAddressProviderSpec: KarhooTestCase {

    private var testUserDefaults: MockUserDefaults!
    private var testObject: KarhooRecentAddressProvider!

    override func setUp() {
        super.setUp()

        testUserDefaults = MockUserDefaults()
        testObject = KarhooRecentAddressProvider(persistantStore: testUserDefaults)
    }

    override func tearDown() {
        super.tearDown()
        testUserDefaults.removeObject(forKey: KarhooRecentAddressProvider.Key.recents.rawValue)
        _ = testUserDefaults.synchronize()
    }

    /**
     *  When:   Adding a recent
     *  Then:   It should be parsed
     *  And:    Stored in the persistant store
     */
    func testAddRecent() {
        let address = TestUtil.getRandomLocationInfo()

        testObject.add(recent: address)
        testUserDefaults.valueToReturn = RecentAddressList(recents: []).encode()!

        XCTAssert(testUserDefaults.setForKeyCalled)
        XCTAssert(testUserDefaults.synchronizeCalled)
    }

    /**
     *  When:   Adding a recent when it's already added
     *  Then:   Address should not be added
     */
    func testAddWhenAlreadyExist() {
        let existingAddress = TestUtil.getRandomLocationInfo()

        testUserDefaults.valueToReturn = RecentAddressList(recents: [existingAddress]).encode()!
        testObject.add(recent: existingAddress)

        XCTAssertFalse(testUserDefaults.setForKeyCalled)
        XCTAssertFalse(testUserDefaults.synchronizeCalled)
    }

    /**
     *  When:   Adding a recent when the limit is already maxed out
     *  Then:   The last existing recent should be removed
     *  And:    The new recent should be first
     */
    func testMaxNoOfRecents() {
        let existingAddresses = [TestUtil.getRandomLocationInfo(placeId: "1"),
                                 TestUtil.getRandomLocationInfo(placeId: "2"),
                                 TestUtil.getRandomLocationInfo(placeId: "3"),
                                 TestUtil.getRandomLocationInfo(placeId: "4"),
                                 TestUtil.getRandomLocationInfo(placeId: "5")]

        let newAddress = TestUtil.getRandomLocationInfo(placeId: "6")
        testUserDefaults.valueToReturn = RecentAddressList(recents: existingAddresses).encode()!
        testObject.add(recent: newAddress)

        XCTAssertTrue(testUserDefaults.setForKeyCalled)
        XCTAssertTrue(testUserDefaults.synchronizeCalled)

        let savedData = testUserDefaults.valueSet as? Data
        let savedAddresses = try? JSONDecoder().decode(RecentAddressList.self, from: savedData!)

        XCTAssertTrue(savedAddresses!.recents.first?.placeId == "6")
        XCTAssertFalse(savedAddresses!.recents.contains(where: { $0.placeId == "5" }))
    }

    /**
     *  When:   Getting recents
     *  Then:   All the recents from the persistent store should be returned
     */
    func testGettingRecents() {
        let testAddress = TestUtil.getRandomLocationInfo()
        testUserDefaults.valueToReturn = RecentAddressList(recents: [testAddress]).encode()!

        let recents = testObject.getRecents()

        XCTAssert(recents.count == 1)
        recents.forEach { (location: LocationInfo) in
            XCTAssert(location.placeId == testAddress.placeId)
        }
    }
}
