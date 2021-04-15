//
//  BookingStatus.swift
//  KarhooSDK
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK

public final class KarhooBookingStatus: BookingStatus {

    private let broadcaster: Broadcaster<AnyObject>
    private var status: BookingDetails?
    private let addressService: AddressService
    public static let shared = KarhooBookingStatus()

    init(broadcaster: Broadcaster<AnyObject> = Broadcaster<AnyObject>(),
         addressService: AddressService = Karhoo.getAddressService()) {
        self.broadcaster = broadcaster
        self.addressService = addressService
    }

    public func add(observer: BookingDetailsObserver) {
        self.broadcaster.add(listener: observer)
    }

    public func remove(observer: BookingDetailsObserver) {
        self.broadcaster.remove(listener: observer)
    }

    public func set(pickup: LocationInfo?) {
        guard let pickup = pickup else {
            broadcastState()
            return
        }

        if status == nil {
            status = BookingDetails(originLocationDetails: pickup)
        } else {
            status?.originLocationDetails = pickup
        }
        broadcastState()
    }

    public func set(destination: LocationInfo?) {
        guard status?.originLocationDetails != nil else {
            return
        }
        status?.destinationLocationDetails = destination
        broadcastState()
    }

    public func set(prebookDate: Date?) {
        guard status?.originLocationDetails != nil else {
            return
        }
        status?.scheduledDate = prebookDate
        broadcastState()
    }

    public func reset() {
        status = nil
        broadcastState()
    }

    public func reset(with bookingDetails: BookingDetails) {
        status = bookingDetails
        broadcastState()
    }

    public func getBookingDetails() -> BookingDetails? {
        return status
    }

    private func broadcastState() {
        broadcaster.broadcast { [weak self] (listener: AnyObject) in
            let listener = listener as? BookingDetailsObserver
            listener?.bookingStateChanged(details: self?.status)
        }
    }

    public func setJourneyInfo(journeyInfo: JourneyInfo?) {
        if Karhoo.configuration.authenticationMethod().isGuest() {
            return
        }

        guard let desiredPickup = journeyInfo?.origin else {
            return
        }

        addressService.reverseGeocode(position: desiredPickup.toPosition()).execute(callback: { [weak self] result in
            if let newPickup = result.successValue() {
                self?.set(pickup: newPickup)
            }
        })
    }
}
