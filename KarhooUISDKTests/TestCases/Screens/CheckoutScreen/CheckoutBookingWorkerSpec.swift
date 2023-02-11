//
//  CheckoutBookingWorkerSpec.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 09/02/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Combine
import Quick
import Nimble
import SwiftUI
import KarhooSDK
import KarhooUISDKTestUtils
@testable import KarhooUISDK

final class KarhooCheckoutBookingWorkerSpec: QuickSpec {

    override func spec() {
        describe("KarhooCheckoutBookingWorker") {
            var mockUserService: MockUserService!
            var mockTripService: MockTripService!
            var mockPaymentWorker: MockCheckoutPaymentWorker!
            var mockLoyaltyWorker: MockLoyaltyWorker!
            var mockPaymentManager: MockPaymentManager!
            var mockSdkConfiguration: KarhooTestConfiguration!
            var mockAnalytics: MockAnalytics!

            var mockQuote: Quote!
            var mockJourneyDetails: JourneyDetails!
            var mockBookingMetadata: [String: Any]?
            var mockPassengerDetails: PassengerDetails!
            var mockTripInfo: TripInfo!
            var mockError: KarhooError!

            var sut: KarhooCheckoutBookingWorker!

            beforeEach {
                mockAnalytics = MockAnalytics()
                mockUserService = MockUserService()
                mockTripService = MockTripService()
                mockPaymentWorker = MockCheckoutPaymentWorker()
                mockPaymentManager = MockPaymentManager(.braintree)
                KarhooTestConfiguration.mockPaymentManager = mockPaymentManager
                mockSdkConfiguration = KarhooTestConfiguration()
                KarhooUI.set(configuration: mockSdkConfiguration)
                mockLoyaltyWorker = MockLoyaltyWorker()

                mockPaymentWorker.storedPaymentNonce = Nonce(nonce: "nonce")
                mockQuote = TestUtil.getSampleQuote(quoteId: "mockQuote")
                mockJourneyDetails = TestUtil.getRandomJourneyDetails()

                sut = KarhooCheckoutBookingWorker(
                    quote: mockQuote,
                    journeyDetails: mockJourneyDetails,
                    bookingMetadata: mockBookingMetadata,
                    userService: mockUserService,
                    tripService: mockTripService,
                    sdkConfiguration: mockSdkConfiguration,
                    paymentWorker: mockPaymentWorker,
                    loyaltyWorker: mockLoyaltyWorker,
                    analytics: mockAnalytics
                )
            }

            context("when booking worker is initialized") {

                it("should have correct initial state") {
                    expect(sut.stateSubject.value).to(equal(.idle))
                }

                it("should setup loyalty and payment workers") {
                    expect(mockLoyaltyWorker.setupCalled).to(beTrue())
                    expect(mockPaymentWorker.setupCalled).to(beTrue())
                }
            }

            // MARK: - Data setup

            context("when data are updated") {
                beforeEach {
                    mockPassengerDetails = TestUtil.getRandomValidPassengerDetails()
                    sut.update(passengerDetails: mockPassengerDetails)
                    sut.update(flightNumber: "flightNumber")
                    sut.update(trainNumber: "trainNumber")
                    sut.update(comment: "comment")
                }

                context("and when all required data are in place") {
                    beforeEach {
                        KarhooTestConfiguration.setGuest()
                        mockPaymentWorker.storedPaymentNonce = Nonce(nonce: "mockNonce")
                        mockPaymentWorker.paymentNonceResult = PaymentNonceProviderResult.nonce(nonce: Nonce(nonce: "mockNonce"))
                    }

                    context("and when perform booking is called") {
                        beforeEach {
                            sut.performBooking()
                        }

                        it("should send request with assigend data") {
                            let requestData = mockTripService.tripBookingSet
                            expect(requestData?.quoteId).to(equal(mockQuote.id))
                            expect(requestData?.flightNumber).to(equal("flightNumber"))
                            expect(requestData?.trainNumber).to(equal("trainNumber"))
                            expect(requestData?.comments).to(equal("comment"))
                            expect(requestData?.paymentNonce).to(equal("mockNonce"))
                        }

                        context("and when tripService returns success") {
                            beforeEach {
                                mockTripInfo = TestUtil.getRandomTrip(tripId: "mockTripInfo")
                                mockTripService.bookCall.triggerSuccess(mockTripInfo)
                            }

                            it("should set state to success") {
                                expect(sut.stateSubject.value).to(equal(.success(mockTripInfo)))
                            }

                            it("should report analytics event") {
                                expect(mockAnalytics.bookingSuccessCalled).to(beTrue())
                            }
                        }
                    }
                }
            }

            // MARK: - Flow handling

            // MARK: KarhooUser flow

            context("when authenticationMethod is .karhooUser") {
                beforeEach {
                    mockPassengerDetails = TestUtil.getRandomValidPassengerDetails()
                    sut.update(passengerDetails: mockPassengerDetails)
                    KarhooTestConfiguration.authenticationMethod = .karhooUser
                }

                context("and there is a stored paymentNonce") {
                    beforeEach {
                        mockPaymentWorker.storedPaymentNonce = Nonce(nonce: "nonce")
                        mockPaymentWorker.getPaymentNonceResult = .completed(value: .nonce(nonce: Nonce(nonce: "mockNonce")))
                    }

                    context("and should get payment before booking") {
                        beforeEach {
                            mockPaymentManager.shouldCheckThreeDSBeforeBookingToReturn = true
                        }

                        context("and when perform booking is called") {
                            beforeEach {
                                sut.performBooking()
                            }

                            it("should call paymentWorker for paymentNonce") {
                                expect(mockPaymentWorker.getPaymentNonceCalled).to(beTrue())
                            }
                        }
                    }

                    context("and should not get payment before booking") {
                        beforeEach {
                            mockPaymentManager.shouldCheckThreeDSBeforeBookingToReturn = false
                        }

                        context("and when perform booking is called") {
                            beforeEach {
                                sut.performBooking()
                            }

                            it("should call tripService for booking") {
                                expect(mockTripService.tripBookingSet).notTo(beNil())
                            }
                        }
                    }
                }

                context("and there is no stored paymentNonce") {
                    beforeEach {
                        mockPaymentWorker.storedPaymentNonce = nil
                    }
                    context("and when perform booking is called") {
                        beforeEach {
                            sut.performBooking()
                        }

                        it("should call paymentWorker for paymentNonce") {
                            expect(mockPaymentWorker.getPaymentNonceCalled).to(beTrue())
                        }
                    }
                }
            }

            // MARK: Guest flow

            context("when authenticationMethod is other than .karhooUser") {
                beforeEach {
                    mockPassengerDetails = TestUtil.getRandomValidPassengerDetails()
                    sut.update(passengerDetails: mockPassengerDetails)
                    KarhooTestConfiguration.setGuest()
                }

                context("and when should get payment before booking") {
                    beforeEach {
                        mockPaymentManager.shouldCheckThreeDSBeforeBookingToReturn = true
                    }

                    context("and when perform booking is called") {
                        beforeEach {
                            sut.performBooking()
                        }

                        it("should call paymentWorker for paymentNonce") {
                            expect(mockPaymentWorker.threeDSecureNonceCheckCalled).to(beTrue())
                        }
                    }

                    context("and when 3DSecure check failed") {
                        beforeEach {
                            mockPaymentWorker.requestNewPaymentMethodResult = { .cancelledByUser }
                            mockPaymentWorker.threeDSSecureNonceCheckResult = .completed(value: .threeDSecureAuthenticationFailed)
                        }

                        context("and when perform booking is called") {
                            beforeEach {
                                sut.performBooking()
                            }

                            it("should set state to .idle") {
                                expect(sut.stateSubject.value).to(equal(.idle))
                            }

                            it("should not call tripService for booking") {
                                expect(mockTripService.tripBookingSet).to(beNil())
                            }

                            it("should call paymentWorker for a new payment method") {
                                expect(mockPaymentWorker.requestNewPaymentMethodCalled).to(beTrue())
                            }
                        }
                    }

                    context("and when 3DSecure check is successful") {
                        beforeEach {
                            mockPaymentWorker.threeDSSecureNonceCheckResult = .completed(value: .success(nonce: "nonce"))
                        }

                        context("and when perform booking is called") {
                            beforeEach {
                                sut.performBooking()
                            }
                            it("should call tripService for booking") {
                                expect(mockTripService.tripBookingSet).notTo(beNil())
                            }
                        }
                    }
                }
            }

            // MARK: - General flow

            context("when all required data are in place") {
                beforeEach {
                    mockPassengerDetails = TestUtil.getRandomValidPassengerDetails()
                    sut.update(passengerDetails: mockPassengerDetails)
                    KarhooTestConfiguration.setGuest()
                    mockPaymentWorker.storedPaymentNonce = Nonce(nonce: "nonce")
                    mockPaymentWorker.paymentNonceResult = PaymentNonceProviderResult.nonce(nonce: Nonce(nonce: "nonce"))
                }

                context("and when perform booking is called") {
                    beforeEach {
                        sut.performBooking()
                    }

                    it("should call tripService for booking") {
                        expect(mockTripService.tripBookingSet).notTo(beNil())
                    }

                    it("should report an analytics event") {
                        expect(mockAnalytics.bookingRequestedCalled).to(beTrue())
                    }
                }

                context("and when perform booking is called") {
                    beforeEach {
                        sut.performBooking()
                    }

                    context("and when booking fails") {
                        beforeEach {
                            mockError = TestUtil.getRandomError()
                            mockTripService.bookCall.triggerFailure(mockError)
                        }

                        it("should call tripService for booking") {
                            expect(mockTripService.tripBookingSet).notTo(beNil())
                        }
                        
                        it("should report an analytics event") {
                            expect(mockAnalytics.bookingFailureCalled).to(beTrue())
                        }

                        it("should set failed booking state") {
                            expect(sut.stateSubject.value).to(equal(.failure(mockError)))
                        }
                    }
                }

                context("and when loyalty is enabled") {
                    beforeEach {
                        mockLoyaltyWorker.isLoyaltyEnabled = true
                    }

                    context("and when perform booking is called") {
                        beforeEach {
                            sut.performBooking()
                        }
                        it("should call loyalty worker for nonce") {
                            expect(mockLoyaltyWorker.getLoyaltyNonceCalled).to(beTrue())
                        }
                    }

                    context("and when loyalty nonce is provided") {
                        beforeEach {
                            mockLoyaltyWorker.getLoyaltyNonceResult = .success(result: LoyaltyNonce(loyaltyNonce: "nonce"), correlationId: "correlationId")
                        }

                        context("and when perform booking is called") {
                            beforeEach {
                                sut.performBooking()
                            }

                            it("should call tripService for booking with loyalty nonce") {
                                expect(mockTripService.tripBookingSet?.loyaltyNonce).to(equal("nonce"))
                            }
                        }
                    }

                    context("and when loyalty error is returned") {
                        beforeEach {
                            mockError = TestUtil.getRandomError()
                            mockLoyaltyWorker.getLoyaltyNonceResult = .failure(error: mockError)
                        }

                        context("and when perform booking is called") {
                            beforeEach {
                                sut.performBooking()
                            }

                            it("should not call tripService for booking") {
                                expect(mockTripService.tripBookingSet).to(beNil())
                            }

                            it("should set state to failed") {
                                expect(sut.stateSubject.value.isFailure).to(beTrue())
                            }
                        }

                        context("and when returned loyalty error is .errMissingBrowserInfo") {
                            beforeEach {
                                mockError = ErrorModel(message: "", code: "KP005")
                                mockLoyaltyWorker.getLoyaltyNonceResult = .failure(error: mockError)
                            }

                            context("and when perform booking is called") {
                                beforeEach {
                                    sut.performBooking()
                                }

                                it("should call tripService for booking without loyalty nonce") {
                                    expect(mockTripService.tripBookingSet?.loyaltyNonce).to(beNil())
                                    expect(mockTripService.tripBookingSet).notTo(beNil())
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

extension CheckoutBookingState {
    var isFailure: Bool {
        switch self {
        case .failure: return true
        default: return false
        }
    }
}
