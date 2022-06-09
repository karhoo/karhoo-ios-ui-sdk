//
//  KarhooTripMetaDataPresenterSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
import KarhooSDK

@testable import KarhooUISDK

final class KarhooTripMetaDataPresenterSpec: KarhooTestCase {

    private var testObject: KarhooTripMetaDataPresenter!
    private var mockTripMetaDataView: MockTripMetaDataView!
    private var mockTripMetaDataActions: MockTripMetaDataActions!
    private var testTrip: TripInfo!
    private var mockFareService = MockFareService()

    override func setUp() {
        super.setUp()

        mockTripMetaDataView = MockTripMetaDataView()
        mockTripMetaDataActions = MockTripMetaDataActions()
        testTrip = TestUtil.getRandomTrip()

        testObject = KarhooTripMetaDataPresenter(tripMetaDataActions: mockTripMetaDataActions,
                                                 trip: testTrip,
                                                 tripMetaDataView: mockTripMetaDataView,
                                                 fareService: mockFareService)
    }
    
    override func tearDown() {
        super.tearDown()
        testObject = nil
    }

    /**
     * When: Initialising presenter
     * Then: View should be set with view model and presenter
     */
    func testInit() {
        XCTAssert((mockTripMetaDataView.setPresenter as? KarhooTripMetaDataPresenter)! === testObject)
        XCTAssertEqual(mockTripMetaDataView.setViewModel?.displayId, testTrip.displayId)
    }

    /**
      * When: Base fare dialog explanation is selected
      * Then: Actions should be called to show said base fare dialog
      */
    func testShowingBaseFareDialog() {
        testObject.baseFareExplanationPressed()

        XCTAssertTrue(mockTripMetaDataActions.showBaseFareDialogCalled)
    }
    
    /**
      * When: TripInfo is completed
      * Then: The fare price should be updated
      */
    func testUpdateFare() {
        testObject.updateFare()
    
        XCTAssertTrue(mockFareService.fareDetailsCalled)
    }
    
    /**
      * When: TripInfo is not completed
      * Then: The fare price shouldn't be updated
      */
    func testUpdateFareNotPerformed() {
        testObject = KarhooTripMetaDataPresenter(tripMetaDataActions: mockTripMetaDataActions,
                                                 trip: TestUtil.getRandomTrip(state: .bookerCancelled),
                                                 tripMetaDataView: mockTripMetaDataView,
                                                 fareService: mockFareService)
        
        testObject.updateFare()
    
        XCTAssertFalse(mockFareService.fareDetailsCalled)
    }
}
