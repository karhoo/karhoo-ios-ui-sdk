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
   
    private let defaults = UserDefaults.standard

    func send(eventName: AnalyticsConstants.EventNames, payload: [String : Any]) {
        let notificationsEnabled = defaults.bool(forKey: notificationEnabledUserDefaultsKey)
        if notificationsEnabled {
            let content = UNMutableNotificationContent()
            content.title = eventName.rawValue
            content.subtitle = payload.description
            content.sound = .default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
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
