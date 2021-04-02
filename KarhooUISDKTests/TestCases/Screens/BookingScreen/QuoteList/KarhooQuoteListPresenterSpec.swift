//
//  KarhooQuoteListPresenterSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
import KarhooSDK
@testable import KarhooUISDK

class KarhooQuoteListPresenterSpec: XCTestCase {

    private var testObject: KarhooQuoteListPresenter!
    private var mockBookingStatus: MockBookingStatus!
    private var mockQuoteService: MockQuoteService!
    private var mockQuoteListView: MockQuoteListView!
    private var mockQuoteSorter: MockQuoteSorter!
    private var mockDateFormatter: MockDateFormatterType!

    static let someQuote = TestUtil.getRandomQuote(categoryName: "Some")
    static let anotherQuote = TestUtil.getRandomQuote(categoryName: "anotherQuote")

    private let quoteServiceResponse = Quotes(quoteListId: "someQuoteListId",
                                              quoteCategories: [QuoteCategory(name: "Some", quotes: [someQuote]),
                                                                QuoteCategory(name: "anotherQuote", quotes: [anotherQuote]),
                                                                QuoteCategory(name: "noQuotes", quotes: [])],
                                              all: [someQuote, anotherQuote])

    private let noQuotesAfterCompleted = Quotes(quoteListId: "someQuoteListId",
                                                quoteCategories: [QuoteCategory(name: "Some", quotes: [someQuote]),
                                                                  QuoteCategory(name: "anotherQuote", quotes: [anotherQuote]),
                                                                  QuoteCategory(name: "noQuotes", quotes: [])],
                                                all: [],
                                                status: .completed)

    override func setUp() {
        super.setUp()

        mockBookingStatus = MockBookingStatus()
        mockQuoteService = MockQuoteService()
        mockQuoteListView = MockQuoteListView()
        mockQuoteSorter = MockQuoteSorter()
        mockDateFormatter = MockDateFormatterType()
        testObject = KarhooQuoteListPresenter(bookingStatus: mockBookingStatus,
                                              quoteService: mockQuoteService,
                                              quoteListView: mockQuoteListView,
                                              quoteSorter: mockQuoteSorter,
                                              dateFormatter: mockDateFormatter)
    }

    private func simulateDestinationSetInBookingDetails(dateSet: Bool = true) {
        let bookingDetailsDestinationSet = TestUtil.getRandomBookingDetails(destinationSet: true,
                                                                            dateSet: dateSet)

        mockBookingStatus.bookingDetailsToReturn = bookingDetailsDestinationSet
        testObject.bookingStateChanged(details: bookingDetailsDestinationSet)
    }

    private func simulateSuccessfulQuoteFetch(dateSet: Bool = true) {
        simulateDestinationSetInBookingDetails(dateSet: dateSet)
        mockQuoteService.quotesPollCall.triggerPollSuccess(quoteServiceResponse)
    }

    private func simulateNoDestinationInBookingDetails() {
        let noDestinationBookingDetails = TestUtil.getRandomBookingDetails(destinationSet: false)

        mockBookingStatus.bookingDetailsToReturn = noDestinationBookingDetails
        testObject.bookingStateChanged(details: noDestinationBookingDetails)
    }

    /**
      * When: Quote search starts
      * Then: Loading view should show
      * And: Quote list should be set to empty list
      */
    func testLoadingViewShowsWithEmptyQuotes() {
        simulateDestinationSetInBookingDetails()
        XCTAssertTrue(mockQuoteListView.quotesSet!.isEmpty)
        XCTAssertTrue(mockQuoteListView.showLoadingViewCalled)
        XCTAssertFalse(mockQuoteListView.toggleSortingFilteringControlsShow ?? true)
    }

    /**
      * Given: Quote search refreshes
      * When: Quote search finishes with results
      * Then: Loading view should hide
      */
    func testLoadingViewHides() {
        simulateDestinationSetInBookingDetails()
        XCTAssertTrue(mockQuoteListView.showLoadingViewCalled)
        XCTAssertFalse(mockQuoteListView.toggleSortingFilteringControlsShow ?? true)

        simulateSuccessfulQuoteFetch()
        XCTAssertTrue(mockQuoteListView.hideLoadingViewCalled)
        XCTAssertTrue(mockQuoteListView.toggleSortingFilteringControlsShow ?? false)
    }

    /**
     * Given: Prebook Quote search refreshes
     * When: Quote search finishes with results
     * Then: Date formatter should been called and have correct time zone
     * And: QuoteSorter should hide
     */
    func testSuccessFetchOfPrebook() {
        simulateSuccessfulQuoteFetch()

        let bookingDetails = mockBookingStatus.bookingDetailsToReturn
        XCTAssertEqual(bookingDetails?.scheduledDate,
                       mockDateFormatter.detailStyleDateSet)

        XCTAssertEqual(bookingDetails?.originLocationDetails?.timezone(),
                       mockDateFormatter.timeZoneSet)

        XCTAssertTrue(mockQuoteListView.hideQuoteSorterCalled)
    }

    /**
     * Given: ASAP Quote search refreshes
     * When: Quote search finishes with results
     * Then: Date formatter should not be called
     * And: QuoteSorter should show
     */
    func testSuccessFetchOfAsap() {
        simulateSuccessfulQuoteFetch(dateSet: false)

        XCTAssertNil(mockDateFormatter.detailStyleDateSet)
        XCTAssertTrue(mockQuoteListView.showQuoteSorterCalled)
    }

    /**
     * Given: Quote search refreshes
     * When: No quotes but result is success (quote search still in progress)
     * Then: Loading view should not hide
     */
    func testLoadingViewShowsDuringQuoteSearchInProgress() {
        simulateDestinationSetInBookingDetails()
        XCTAssertTrue(mockQuoteListView.showLoadingViewCalled)
        XCTAssertFalse(mockQuoteListView.toggleSortingFilteringControlsShow ?? true)

        mockQuoteService.quotesPollCall.triggerPollSuccess(Quotes(quoteListId: "some",
                                                                  quoteCategories: [],
                                                                  all: []))
        XCTAssertFalse(mockQuoteListView.hideLoadingViewCalled)
        XCTAssertTrue(mockQuoteListView.toggleSortingFilteringControlsShow ?? false)
    }

    /**
     * Given: A successful quote fetch has occured
     * When: A quote category is selected
     * Then: View should update with quotes of selected category (not animated)
     */
    func testQuotesSetFromObserverNotAnimated() {
        testObject.selectedQuoteCategory(QuoteCategory(name: UITexts.Availability.allCategory, quotes: []))
        simulateSuccessfulQuoteFetch()

        XCTAssertFalse(mockQuoteListView.showQuotesAnimated!)
    }

    /**
     * Given: A successful quote fetch has occured
     * When: A quote category is selected
     * Then: View should update with quotes of selected category (animated)
     */
    func testSelectingCategoryFiltersQuotes() {
        simulateSuccessfulQuoteFetch()
        mockQuoteSorter.quotesToReturn = [KarhooQuoteListPresenterSpec.someQuote]

        testObject.selectedQuoteCategory(QuoteCategory(name: "Some", quotes: []))
        XCTAssertTrue(mockQuoteListView.showQuotesAnimated!)
        XCTAssertTrue(mockQuoteListView.quotesSet!.contains(KarhooQuoteListPresenterSpec.someQuote))
        XCTAssertEqual(1, mockQuoteListView.quotesSet?.count)
    }

    /**
     * Given: A successful quote fetch has occured
     * When: A quote category is selected that has no quotes
     * Then: View should update with empty category message
     */
    func testSelectingEmptyCategory() {
        simulateSuccessfulQuoteFetch()

        testObject.selectedQuoteCategory(QuoteCategory(name: "noQuotes", quotes: []))

        XCTAssertEqual(UITexts.Availability.noQuotesInSelectedCategory, mockQuoteListView.emptyDataSetMessageSet)
    }

    /**
     * Given: Booking details change for the first time
     * When: There is a destination
     * And: Then quote search should be subscribed
     */
    func testBookingDetailsDestinationSetCallsQuoteService() {
        simulateDestinationSetInBookingDetails()
        XCTAssertNotNil(mockQuoteService.quoteSearchSet)
        XCTAssertTrue(mockQuoteService.quotesPollCall.hasObserver)
    }

    /**
     * Given: Booking details change for the second time
     * Then: Then quote search should be unsubscribed
     * And: quote search should be subscribed
     */
    func testQuoteListObserverRemovedBeforeNewSearch() {
        simulateDestinationSetInBookingDetails()
        simulateDestinationSetInBookingDetails()

        XCTAssertTrue(mockQuoteService.quotesPollCall.mockObservable.unsubscribeCalled)
        XCTAssertNotNil(mockQuoteService.quoteSearchSet)
        XCTAssertTrue(mockQuoteService.quotesPollCall.hasObserver)
    }

    /**
     * Given: Valid booking details
     * When: Quote service receives quotes
     * Then: Quote service receives 0 quotes
     * And: LoadingView should appear
     * Then: Quote service receives quotes
     * And: LoadingView should hide
     */
    func testNoQuotesResponse() {
        simulateSuccessfulQuoteFetch()

        mockQuoteListView.showLoadingViewCalled = false
        mockQuoteListView.hideLoadingViewCalled = false
        mockQuoteListView.toggleSortingFilteringControlsShow = nil

        mockQuoteService.quotesPollCall.triggerPollSuccess(Quotes(quoteListId: "",
                                                                  quoteCategories: [],
                                                                  all: []))
        XCTAssertTrue(mockQuoteListView.showLoadingViewCalled)
        XCTAssertFalse(mockQuoteListView.toggleSortingFilteringControlsShow ?? true)
        XCTAssertFalse(mockQuoteListView.hideLoadingViewCalled)

        mockQuoteService.quotesPollCall.triggerPollSuccess(quoteServiceResponse)
        XCTAssertTrue(mockQuoteListView.hideLoadingViewCalled)
        XCTAssertTrue(mockQuoteListView.toggleSortingFilteringControlsShow ?? false)

    }

    /**
     * Given: Valid booking details
     * When: Quote service receives quotes
     * Then: Quote service receives 0 quotes
     * And: LoadingView should appear
     * Then: Quote service receives quotes
     * And: LoadingView should hide
     */
    func testNoQuotesAfterCompletedResponse() {
        simulateDestinationSetInBookingDetails(dateSet: true)

        mockQuoteListView.showLoadingViewCalled = false
        mockQuoteListView.hideLoadingViewCalled = false
        mockQuoteListView.toggleSortingFilteringControlsShow = nil

        mockQuoteService.quotesPollCall.triggerPollSuccess(Quotes(quoteListId: "",
                                                                  quoteCategories: [],
                                                                  all: [],
                                                                  status: .progressing))
        XCTAssertTrue(mockQuoteListView.showLoadingViewCalled)
        XCTAssertFalse(mockQuoteListView.toggleSortingFilteringControlsShow ?? true)
        XCTAssertFalse(mockQuoteListView.hideLoadingViewCalled)

        mockQuoteService.quotesPollCall.triggerPollSuccess(noQuotesAfterCompleted)
        XCTAssertTrue(mockQuoteListView.hideLoadingViewCalled)
        XCTAssertTrue(mockQuoteListView.toggleSortingFilteringControlsShow ?? false)

    }

    /**
     * Given: Valid booking details
     * When: Quote service gives out a no availability error
     * Then: Correct message should be propogated to the empty data set view
     * And: Quote service observer should be unsubscribed
     * And: Loading view should be hidden
     */
    func testNoAvailabilityResponseFromQuoteService() {
        simulateDestinationSetInBookingDetails()
        mockQuoteService.quotesPollCall.triggerPollFailure(TestUtil.getRandomError(code: "K3002"))

        XCTAssertFalse(mockQuoteListView.availabilityValue)
        XCTAssertFalse(mockQuoteService.quotesPollCall.hasObserver)
        XCTAssertTrue(mockQuoteListView.hideLoadingViewCalled)
        XCTAssertTrue(mockQuoteListView.toggleSortingFilteringControlsShow ?? false)
    }

    /**
     * Given: Valid booking details
     * When: Quote service gives out a origin / destination the same error
     * Then: Correct message should be propogated to the empty data set view
     * And: Quote service observer should be unsubscribed
     * And: Loading view should be hidden
     */
    func testOriginDestinationTheSameErrorFromQuoteService() {
        simulateDestinationSetInBookingDetails()
        mockQuoteService.quotesPollCall.triggerPollFailure(TestUtil.getRandomError(code: "Q0001"))

        XCTAssertEqual(mockQuoteListView.emptyDataSetMessageSet, UITexts.KarhooError.Q0001)
        XCTAssertFalse(mockQuoteService.quotesPollCall.hasObserver)
        XCTAssertTrue(mockQuoteListView.hideLoadingViewCalled)
        XCTAssertTrue(mockQuoteListView.toggleSortingFilteringControlsShow ?? false)
    }

    /**
      * When: Quote sort order changes
      * Then: View should show quotes animated
      */
    func testQuoteSortOrderChange() {
        simulateSuccessfulQuoteFetch()

        testObject.didSelectQuoteOrder(.price)

        XCTAssertTrue(mockQuoteListView.showQuotesAnimated!)
    }
}
