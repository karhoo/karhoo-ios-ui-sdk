//
//  TripFeedbackPresenterSpec.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
import KarhooSDK
@testable import KarhooUISDK

final class TripFeedbackPresenter: XCTestCase {

    private var testObject: KarhooTripFeedbackPresenter!
    private var testTripId = "testTripId"
    private var mockAnalyticsService = MockAnalyticsService()
    private var mockTripFeedbackView = MockTripFeedbackView()
    private var mockTripRatingCache = MockTripRatingCache()

    var lastCallbackResult: ScreenResult<Void>?
    private func testCallback(result: ScreenResult<Void>) {
        lastCallbackResult = result
    }

    override func setUp() {
        super.setUp()

        testObject = KarhooTripFeedbackPresenter(tripId: self.testTripId, analyticsService: mockAnalyticsService,
                                                 callback: testCallback, tripRatingCache: mockTripRatingCache)
        testObject.set(view: mockTripFeedbackView)
    }

    /**
     * Given: A TripFeedback has been initilised
     * Then: Calling getTripId, the correct value is returned
     */
    func test_correct_tripId_returned() {
        let expected_tripId = testObject.getTripId()
        
        XCTAssertEqual(testTripId, expected_tripId)
    }
    /**
     * Given: A TripFeedback has been initilised
     * And: A new feedback is provided
     * Then: feedbackPayload should be updated containing the new element
     */
    func test_feedback_added_correctly() {
        
        XCTAssertEqual(testObject.feedbackPayload.count, 0)
        
        let newFeedback: [String: Any] = ["testkey": 2,
                                          "testKey2": "hello"]
        testObject.addFeedback(feedback: newFeedback)
        
        XCTAssertEqual(testObject.feedbackPayload.count, 1)
    }
    /**
     * Given: An array of feedback has been provided
     * And: Sumbit feedback is invoked
     * Then: feedbackPayload should be updated containig the new element
     */
    func test_additional_feedbacks_submitted() {
        
        let newFeedback1: [String: Any] = ["testkey": 2,
                                          "testKey2": "hello"]
        let newFeedback2: [String: Any] = ["testkey": 2,
                                          "testKey2": "hello"]
        
        testObject.addFeedback(feedback: newFeedback1)
        testObject.addFeedback(feedback: newFeedback2)
        
        let expectedPayload: [String: Any] = ["tripId": testTripId,
                                              "source": "MOBILE",
                                              AnalyticsConstants.EventNames.additional_feedback.rawValue:
                                                testObject.feedbackPayload,
                                              "timestamp": Date().timeIntervalSince1970]
        
        XCTAssertEqual(testObject.feedbackPayload.count, 2)
        
        testObject.submitButtonPressed()

        XCTAssertEqual(mockAnalyticsService.eventSent, .additional_feedback_submitted)
        
        let eventPayload = mockAnalyticsService.eventPayloadSent!
        XCTAssertTrue(eventPayload["source"] as? String == expectedPayload["source"] as? String)
        XCTAssertTrue(eventPayload["type"] as? String == expectedPayload["type"] as? String)
        XCTAssertTrue(eventPayload["tripId"] as? String == expectedPayload["tripId"] as? String)
        let eventPayloadFeedback: [[String: Any]]? = eventPayload["additional_feedback"] as? [[String: Any]]
        let expectedPayloadFeedback: [[String: Any]]? = expectedPayload["additional_feedback"] as? [[String: Any]]
        XCTAssertEqual(eventPayloadFeedback?.count, expectedPayloadFeedback?.count)
        
        XCTAssertTrue(lastCallbackResult!.isComplete())

        XCTAssertTrue(mockTripRatingCache.saveTripRatingCalled)
    }
}
