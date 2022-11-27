//
//  AddToCalendarWorker.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 27/11/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import EventKit
import KarhooSDK

protocol AddToCalendarWorker: AnyObject {
    func addToCalendar(_ trip: TripInfo, completion: @escaping (Bool) -> Void)
}

final class KarhooAddToCalendarWorker: AddToCalendarWorker {

    private let eventStore = EKEventStore()

    func addToCalendar(_ trip: TripInfo, completion: @escaping (Bool) -> Void) {
        eventStore.requestAccess(to: .event) { [weak self] granted, error in
            guard let self = self, granted, error == nil else {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            let result = self.createEvent(trip)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    private func createEvent(_ trip: TripInfo) -> Bool {
        guard let startDate = trip.dateScheduled else {
            assertionFailure("Trip added to the Calendar needs to be scheduled")
            return false
        }
        let event = EKEvent(eventStore: eventStore)
        event.title = "Ride to \(trip.destination?.displayAddress ?? "")"
        event.startDate = startDate
        event.endDate = startDate.addingTimeInterval(TimeInterval(trip.tripQuote.qtaHighMinutes * 60))
        event.notes = """
        \(trip.origin.displayAddress) –> \(trip.destination?.displayAddress ?? "")
        \(startDate.toString(format: .longReadable))
        \(trip.fleetInfo.name)
        \(trip.trainNumber)
        \(trip.flightNumber)
        """
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.save(event, span: .thisEvent)
            return true
        } catch {
            print("Error saving event in calendar: \(error)")
            return false
        }
    }
}
