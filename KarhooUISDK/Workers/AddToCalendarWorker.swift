//
//  AddToCalendarWorker.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 27/11/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import EventKit
import Foundation
import KarhooSDK

protocol AddToCalendarWorker: AnyObject {
    func addToCalendar(_ trip: TripInfo, completion: @escaping (Bool) -> Void)
}

final class KarhooAddToCalendarWorker: AddToCalendarWorker {

    private let eventStore = EKEventStore()
    private let dateFormatter: DateFormatterType

    init(
        dateFormatter: DateFormatterType = KarhooDateFormatter()
    ) {
        self.dateFormatter = dateFormatter
    }

    func addToCalendar(_ trip: TripInfo, completion: @escaping (Bool) -> Void) {
        if #available(iOS 17.0, *) {
            eventStore.requestWriteOnlyAccessToEvents { [weak self] granted, error in
                guard let self = self else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }
                self.handleCalendarAccessResponse(
                    trip: trip,
                    granted: granted,
                    error: error,
                    completion: completion
                )
            }
            
        } else {
            eventStore.requestAccess(to: .event) { [weak self] granted, error in
                guard let self = self else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }
                self.handleCalendarAccessResponse(
                    trip: trip,
                    granted: granted,
                    error: error,
                    completion: completion
                )
            }
        }
    }
    
    private func handleCalendarAccessResponse(
        trip: TripInfo,
        granted: Bool,
        error: Error?,
        completion: @escaping (Bool) -> Void
    ) {
        guard granted, error == nil else {
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

    private func createEvent(_ trip: TripInfo) -> Bool {
        guard let startDate = trip.dateScheduled else {
            assertionFailure("Trip added to the Calendar needs to be scheduled")
            return false
        }
        let event = EKEvent(eventStore: eventStore)
        event.title = String(format: UITexts.TripSummary.calendarEventTitle, trip.destination?.displayAddress ?? "")
        event.startDate = startDate
        event.endDate = startDate.addingTimeInterval(TimeInterval(trip.tripQuote.qtaHighMinutes))
        event.addAlarm(EKAlarm(relativeOffset: -60*60))
        event.addAlarm(EKAlarm(relativeOffset: -3*60*60))
        event.notes = buildNotes(for: trip)
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.save(event, span: .thisEvent)
            return true
        } catch {
            print("Error saving event in calendar: \(error)")
            return false
        }
    }

    private func buildNotes(for trip: TripInfo) -> String {
        var trainNumberDescription: String {
            guard trip.trainNumber.isNotEmpty else {
                return ""
            }
            return "\(UITexts.TripSummary.trainNumber): \(trip.trainNumber)"
        }
        var flightNumberDescription: String {
            guard trip.flightNumber.isNotEmpty else {
                return ""
            }
            return "\(UITexts.TripSummary.flightNumber): \(trip.flightNumber)"
        }

        var tripDateDescription: String {
            dateFormatter.set(timeZone: trip.origin.timezone())
            return dateFormatter.display(mediumStyleDate: trip.dateScheduled) + " " + dateFormatter.display(clockTime: trip.dateScheduled)
        }

        return """
        \(UITexts.TripSummary.tripSummary)
        \(trip.origin.displayAddress) –> \(trip.destination?.displayAddress ?? "")
        \(UITexts.TripSummary.date): \(tripDateDescription)
        \(UITexts.TripSummary.fleet): \(trip.fleetInfo.name)
        \(UITexts.TripSummary.vehicle): \(trip.vehicle.description)
        \(trainNumberDescription)
        \(flightNumberDescription)
        """
    }
}
