//
//  KarhooQuoteCategoryBarPresenterSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooSDK

@testable import KarhooUISDK

class KarhooQuoteCategoryBarPresenterSpec: XCTestCase {

    private var mockView: MockQuoteCategoryBarView!
    private var mockAppAnalytics: MockAnalytics!
    private var mockJourneyDetailsManager: MockJourneyDetailsManager!
    private var testObject: KarhooQuoteCategoryBarPresenter!

    override func setUp() {
        super.setUp()

        mockView = MockQuoteCategoryBarView()
        mockAppAnalytics = MockAnalytics()
        mockJourneyDetailsManager = MockJourneyDetailsManager()
        testObject = KarhooQuoteCategoryBarPresenter(analytics: mockAppAnalytics,
                                                     journeyDetailsManager: mockJourneyDetailsManager,
                                                     view: mockView)

    }

    /**
      * When: Booking details changed
      * Then: Categories shoud reset
      */
    func testChangingBookingDetailsClearsCategories() {
        let changedJourneyDetails = TestUtil.getRandomJourneyDetails()
        testObject.journeyDetailsChanged(details: changedJourneyDetails)

        XCTAssertTrue(mockView.categoriesSet!.isEmpty)
    }

    /**
     * Given:   Availability has not been loaded
     * When:    Delegates had been set
     * Then:    Nothing should happen (no crash / values of testview should be nil)
     */
    func testCategoriesNotUpdated() {
        XCTAssertNil(mockView.categoriesSet)
        XCTAssertNil(mockView.indexSelected)
    }

    func createCategories(withNames names: [String]) -> [QuoteCategory] {
        return names.map { QuoteCategory(name: $0, quotes: []) }
    }

    /**
     * Given:   Availability has been loaded
     * When:    Delegates had been set
     * Then:    It should immediately be informed about the available cars
     *  And:    The last category [ALL] should be selected
     */
    func testCategoriesChanged() {
        let categories = createCategories(withNames: ["ABC", "def", "ÄÖ"])
        let expectedCategories = createCategories(withNames: ["ABC", "def", "ÄÖ", UITexts.Availability.allCategory])
        testObject.categoriesChanged(categories: categories, quoteListId: nil)

        XCTAssertEqual(expectedCategories, mockView.categoriesSet)
        XCTAssertEqual(expectedCategories.count - 1, mockView.indexSelected)
    }

    /**
     * Given:   The selected category does not exist amongst the received items
     * When:    New categories have been received
     * Then:    The view should be told about them
     *  And:    The final category should be selected
     */
    func testNewAvailability() {
        
        let categories = createCategories(withNames: ["ABC", "def", "ÄÖ"])
        let expectedCategories = createCategories(withNames: ["ABC", "def", "ÄÖ", UITexts.Availability.allCategory])
        let selectedIndex = expectedCategories.count - 1
        testObject.categoriesChanged(categories: categories, quoteListId: nil)

        XCTAssertEqual(expectedCategories, mockView.categoriesSet!)
        XCTAssertEqual(selectedIndex, mockView.indexSelected)
        
        let nextCategories = createCategories(withNames: ["ABC", "def"])
        let nextExpectedCategories = createCategories(withNames: ["ABC", "def", UITexts.Availability.allCategory])
        testObject.categoriesChanged(categories: nextCategories, quoteListId: nil)

        XCTAssertEqual(nextExpectedCategories, mockView.categoriesSet!)
        XCTAssertEqual(nextExpectedCategories.count - 1, mockView.indexSelected)
    }

    /**
     * Given:   The selected category exists amongst the received items
     * When:    New categories have been received
     * Then:    The view should be told about them
     *  And:    The selected category index should point to the same category
     */
    func testUpdatedCategoryPosition() {
        
        let selectedIndex = 1
        let categories = createCategories(withNames: ["ABC", "def", "ÄÖ"])
        testObject.categoriesChanged(categories: categories, quoteListId: nil)
        testObject.selected(index: selectedIndex, animated: false)

        let categories2 = createCategories(withNames: ["abc", "ÄÖ", "hej", "def"])
        let expectedCategories2 = createCategories(withNames: ["abc", "ÄÖ", "hej", "def",
                                                               UITexts.Availability.allCategory])
        testObject.categoriesChanged(categories: categories2, quoteListId: nil)

        XCTAssertEqual(expectedCategories2, mockView.categoriesSet!)
        XCTAssertEqual(selectedIndex, mockView.indexSelected)
    }

    /**
     * When:    A different category has been selected
     * Then:    The available items should be filtered based on that category
     *  And:    The view should display that category as selected
     *  And:    VehicleTypeSelected analytics event should be fired
     */
    func testCategorySelection() {
        let categories = createCategories(withNames: ["ABC", "def", "ÄÖ"])
        testObject.categoriesChanged(categories: categories, quoteListId: nil)

        let index = 1
        testObject.selected(index: index, animated: false)

        XCTAssertEqual(index, mockView.indexSelected)
    }

    /**
     * When:    A different category has been selected
     *  Then:    The view selected index should be updated
     */
    func testSameCategorySelection() {
        let categories = createCategories(withNames: ["ABC", "def", "ÄÖ"])
        testObject.categoriesChanged(categories: categories, quoteListId: nil)

        let index = 1
        testObject.selected(index: index, animated: false)

        XCTAssertEqual(1, mockView.indexSelected)
    }

    /**
     * When:    An invalid category has been selected
     * Then:    Nothing should happen (no crash)
     */
    func testInvalidCategorySelection() {
        let categories: [QuoteCategory] = []
        testObject.categoriesChanged(categories: categories, quoteListId: nil)

        let index = 0
        testObject.selected(index: index, animated: false)

        XCTAssertNil(mockView.indexSelected)
    }

    /**
     *  Given:  Categories ['MPV', 'ALL'] received
     *    And:  'MPV' selected
     *   When:  Categories ['TAXI', 'ALL'] received (e.g. switching to a different city)
     *   Then:  'ALL' should be selected
     *    And:  View should have index 1 [last] selected
     */
    func testSwitchingFromMissingCategory() {
        let categoriesOne = createCategories(withNames: ["MPV"])
        
        let selectedIndex = 0
        testObject.categoriesChanged(categories: categoriesOne, quoteListId: nil)
        testObject.selected(index: selectedIndex, animated: false)

        XCTAssertEqual(selectedIndex, mockView.indexSelected)

        let categoriesTwo = createCategories(withNames: ["TAXI"])
        testObject.categoriesChanged(categories: categoriesTwo, quoteListId: nil)

        XCTAssertEqual(selectedIndex, mockView.indexSelected)
    }
}
