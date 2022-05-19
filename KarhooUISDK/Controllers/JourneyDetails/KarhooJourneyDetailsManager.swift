//
//  BookingStatus.swift
//  KarhooSDK
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK

public final class KarhooJourneyDetailsManager: JourneyDetailsManager {

    private let broadcaster: Broadcaster<AnyObject>
    private var status: JourneyDetails?
    private let addressService: AddressService
    public static let shared = KarhooJourneyDetailsManager()

    init(broadcaster: Broadcaster<AnyObject> = Broadcaster<AnyObject>(),
         addressService: AddressService = Karhoo.getAddressService()) {
        self.broadcaster = broadcaster
        self.addressService = addressService
    }

    public func add(observer: JourneyDetailsObserver) {
        self.broadcaster.add(listener: observer)
    }

    public func remove(observer: JourneyDetailsObserver) {
        self.broadcaster.remove(listener: observer)
    }

    public func set(pickup: LocationInfo?) {
        guard let pickup = pickup else {
            broadcastState()
            return
        }

        if status == nil {
            status = JourneyDetails(originLocationDetails: pickup)
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

    public func reset(with journeyDetails: JourneyDetails) {
        status = journeyDetails
        broadcastState()
    }

    public func getJourneyDetails() -> JourneyDetails? {
        return status
    }

    private func broadcastState() {
        broadcaster.broadcast { [weak self] (listener: AnyObject) in
            let listener = listener as? JourneyDetailsObserver
            listener?.journeyDetailsChanged(details: self?.status)
        }
    }

    public func setJourneyInfo(journeyInfo: JourneyInfo?) {
        guard let desiredPickup = journeyInfo?.origin else {
            return
        }

        addressService.reverseGeocode(position: desiredPickup.toPosition()).execute(callback: { [weak self] result in
            if let newPickup = result.successValue() {
                self?.set(pickup: newPickup)
                self?.set(prebookDate: journeyInfo?.date)

                if let destination = journeyInfo?.destination {
                    self?.addressService.reverseGeocode(position: destination.toPosition()).execute(callback: { [weak self] result in
                        if let newDestination = result.successValue() {
                            self?.set(destination: newDestination)
                        }
                    })
                }
            }
        })
    }
}
