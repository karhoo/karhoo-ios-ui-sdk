//
//  CancelRideBehaviour.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK

protocol CancelRideDelegate: AnyObject {
    func showLoadingOverlay()
    func hideLoadingOverlay()
    func sendCancelRideNetworkRequest(callback: @escaping CallbackClosure<KarhooVoid>)
    func sendCancellationFeeNetworkRequest(callback: @escaping CallbackClosure<CancellationFee>)
}

protocol CancelRideBehaviourProtocol: AnyObject {
    var delegate: CancelRideDelegate? { get set }
    func cancelPressed()
    func triggerCancelRide()
    func showCancellationFeeAlert(cancellationFee: CancellationFee)
}

final class CancelRideBehaviour: CancelRideBehaviourProtocol {
    private(set) var trip: TripInfo
    private let alertHandler: AlertHandlerProtocol
    private let phoneNumberCaller: PhoneNumberCallerProtocol
    public weak var delegate: CancelRideDelegate?

    public init(trip: TripInfo,
                delegate: CancelRideDelegate? = nil,
                alertHandler: AlertHandlerProtocol,
                phoneNumberCaller: PhoneNumberCallerProtocol = PhoneNumberCaller()) {
        self.trip = trip
        self.delegate = delegate
        self.alertHandler = alertHandler
        self.phoneNumberCaller = phoneNumberCaller
    }

    public func triggerCancelRide() {
        cancelBookingConfirmed()
    }
    
    public func cancelPressed() {
        getBookingCancellationFee()
    }
    
    public func getBookingCancellationFee() {
        delegate?.showLoadingOverlay()

        delegate?.sendCancellationFeeNetworkRequest { [weak self] result in
            self?.delegate?.hideLoadingOverlay()

            if result.errorValue() != nil {
                //TODO Change this display
                self?.showCancellationFailedAlert()
            }
        }
    }
    
    public func showCancellationFeeAlert(cancellationFee: CancellationFee) {
        let message: String
        if(cancellationFee.fee.value > 0) {
            let feeString = CurrencyCodeConverter.toPriceString(price: Double(cancellationFee.fee.value), currencyCode: cancellationFee.fee.currency)
            message = String(format: UITexts.Bookings.cancellationFeeCharge, feeString)
        } else {
            message = UITexts.Bookings.cancellationFeeContinue
        }

        _ = alertHandler.show(title: UITexts.Trip.tripCancelBookingConfirmationAlertTitle,
                              message: message,
                              actions: [
                                 AlertAction(title: UITexts.Generic.no, style: .default, handler: { [weak self] _ in
                                    self?.delegate?.hideLoadingOverlay()
                                }),
                                AlertAction(title: UITexts.Generic.yes, style: .default, handler: { [weak self] _ in
                                 self?.triggerCancelRide()
                                })
                            ])
    }

    private func cancelBookingConfirmed() {
        delegate?.showLoadingOverlay()

        delegate?.sendCancelRideNetworkRequest { [weak self] result in
            self?.delegate?.hideLoadingOverlay()

            if result.errorValue() != nil {
                self?.showCancellationFailedAlert()
            }
        }
    }

    private func callFleetPressed() {
        phoneNumberCaller.call(number: trip.fleetInfo.phoneNumber)
    }

    private func showConfirmCancelRideAlert() {
        _ = alertHandler.show(title: UITexts.Trip.tripCancelBookingConfirmationAlertTitle,
                              message: UITexts.Trip.tripCancelBookingConfirmationAlertMessage,
                              actions: [
                                AlertAction(title: UITexts.Generic.no, style: .default, handler: nil),
                                AlertAction(title: UITexts.Generic.yes, style: .default, handler: { [weak self] _ in
                                    self?.cancelBookingConfirmed()
                                })
                            ])
    }

    private func showCancellationFailedAlert() {
        let callFleet = UITexts.Trip.tripCancelBookingFailedAlertCallFleetButton

        _ = alertHandler.show(title: UITexts.Trip.tripCancelBookingFailedAlertTitle,
                              message: UITexts.Trip.tripCancelBookingFailedAlertMessage,
                              actions: [
                                AlertAction(title: UITexts.Generic.cancel, style: .default, handler: nil),
                                AlertAction(title: callFleet, style: .default, handler: { [weak self] _ in
                                    self?.callFleetPressed()
                                })
                            ])
    }
    
    private func hideOverlay() {
        
    }
}
