//
//  BookingRequestMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

protocol BookingRequestPresenter {

    func load(view: BookingRequestView)

    func bookTripPressed()

    func didPressAddFlightDetails()
    
    func addOrEditPassengerDetails()
    
    func addMoreDetails()
    
    func didAddPassengerDetails()

    func didPressFareExplanation()

    func didPressClose()

    func screenHasFadedOut()
    
    func isKarhooUser() -> Bool
}

protocol BookingRequestView: BaseViewController {

    func showBookingRequestView(_ show: Bool)

    func setRequestingState()

    func setAddFlightDetailsState()
    
    func setPassenger(details: PassengerDetails?)
    
    func setMoreDetailsState()

    func setDefaultState()

    func set(quote: Quote)

    func set(price: String?)

    func set(quoteType: String)

    func set(baseFareExplanationHidden: Bool)

    func setAsapState(qta: String?)

    func setPrebookState(timeString: String?, dateString: String?)

    func retryAddPaymentMethod()

    func getPaymentNonce() -> String?

    func getPassengerDetails() -> PassengerDetails?
    
    func getComments() -> String?
    
    func getFlightNumber() -> String?
}

extension BookingRequestView {
    func getComments() -> String? {
        return nil
    }
    
    func getFlightNumber() -> String? {
        return nil
    }
}
