//
//  KarhooAnalitycsServiceWithNotifications.swift
//  Client
//
//  Created by Bartlomiej Sopala on 17/08/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

class KarhooAnalitycsServiceWithNotifications: AnalyticsService {

    static public let karhooNotificationIdentifierPrefix = "karhooNotificationIdentifierPrefix_"

    private let defaults = UserDefaults.standard

    func send(eventName: AnalyticsConstants.EventNames, payload: [String : Any]) {
        let notificationsEnabled = defaults.bool(forKey: notificationEnabledUserDefaultsKey)
        if notificationsEnabled {
            let content = UNMutableNotificationContent()
            content.title = eventName.rawValue
            let body = "EVENT: \(eventName.rawValue)\nPAYLOAD: \(payload.description)"
            content.body = body
            content.sound = .default
            content.userInfo["payload_body"] = body
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: Self.karhooNotificationIdentifierPrefix + UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if error != nil {
                   print(error)
                }
             }
        }
    }
    
    func send(eventName: AnalyticsConstants.EventNames) {
        send(eventName: eventName, payload: [:])
    }
}
