//
// Created by Aleksander Wedrychowski on 06/10/2022.
// Copyright (c) 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import NotificationCenter

protocol LocalNotificationWorker: AnyObject {
    func show(notification: LocalNotification)
    func showNotification(title: String, body: String, identifier: String)
    func cancelNotification(identifier: String)
}

final class KarhooLocalNotificationWorker: NSObject, LocalNotificationWorker {

    // MARK: - Properties

    private let notificationCenter: UNUserNotificationCenter

    // MARK: - Lifecycle

    init(notificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()) {
        self.notificationCenter = notificationCenter
    }

    // MARK: - Endpoints

    func show(notification: LocalNotification) {
        let content = UNMutableNotificationContent()
        content.title = notification.title
        content.body = notification.body
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(
            identifier: notification.identifier,
            content: content,
            trigger: nil
        )
        show(request: request)
    }

    func showNotification(title: String, body: String, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: nil
        )
        show(request: request)
    }

    func show(request: UNNotificationRequest) {
        checkNotificationPermissionStatus()

        notificationCenter.add(request) { error in
            if let error = error {
                print("Error showing notification: \(error)")
            }
        }
    }

    func cancelNotification(identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    // MARK: - Private

    private func requestNotificationPermission() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }
    }

    private func checkNotificationPermissionStatus() {
        notificationCenter.getNotificationSettings { settings in
            if settings.authorizationStatus == .notDetermined {
                self.requestNotificationPermission()
            }
        }
    }
}