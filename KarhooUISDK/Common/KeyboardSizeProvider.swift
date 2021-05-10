//
//  KeyboardSizeProvider.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK

protocol KeyboardListener: class {
    func keyboard(updatedHeight: CGFloat)
}

protocol KeyboardSizeProviderProtocol {
    func remove(listener: KeyboardListener)
    func register(listener: KeyboardListener)
}

final class KeyboardSizeProvider: KeyboardSizeProviderProtocol {

    public static let shared = KeyboardSizeProvider()
    private let broadcaster: Broadcaster<AnyObject>

    init(broadcaster: Broadcaster<AnyObject> = Broadcaster<AnyObject>()) {
        self.broadcaster = broadcaster
    }

    func remove(listener: KeyboardListener) {
        broadcaster.remove(listener: listener)

        if broadcaster.hasListeners() == false {
            NotificationCenter.default.removeObserver(self) // swiftlint:disable:this notification_center_detachment
        }
    }

    func register(listener: KeyboardListener) {
        if broadcaster.hasListeners() == false {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(keyboardWillShow(_:)),
                                                   name: UIResponder.keyboardWillShowNotification,
                                                   object: nil)

            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(keyboardWillHide(_:)),
                                                   name: UIResponder.keyboardWillHideNotification,
                                                   object: nil)
        }
        broadcaster.add(listener: listener)

    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        let rawKeyboardFrame: Any? = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
        guard let keyboardRect = (rawKeyboardFrame as? NSValue)?.cgRectValue else {
            return
        }

        broadcaster.broadcast { (listener: AnyObject) in
            guard let listener = listener as? KeyboardListener else {
                return
            }
            listener.keyboard(updatedHeight: keyboardRect.height)
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        broadcaster.broadcast { listener in
            guard let listener = listener as? KeyboardListener else {
                return
            }

            listener.keyboard(updatedHeight: 0)
        }
    }
}
