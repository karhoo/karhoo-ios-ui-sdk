//
//  AlertHandler.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

public class AlertAction {
    public typealias AlertHandler = ((UIAlertAction) -> Void)

    public let action: UIAlertAction
    public let handler: AlertHandler?

    public init(title: String?, style: UIAlertAction.Style, handler: AlertHandler? = nil) {
        self.handler = handler
        action = UIAlertAction(title: title, style: style, handler: handler)
    }

    public var title: String? {
        return action.title
    }
}

public protocol AlertHandlerProtocol {
    func show(title: String?, message: String?) -> UIAlertController
    func show(title: String?, message: String?, actions: [AlertAction]) -> UIAlertController
    func show(error: KarhooError?) -> UIAlertController
}

public extension AlertHandlerProtocol {
    func show(message: String) {
        _ = show(title: nil, message: message)
    }
}

public final class AlertHandler: AlertHandlerProtocol {

    private weak var viewController: UIViewController?
    private weak var presentingViewController: UIViewController? {
        return viewController?.presentedViewController ?? viewController
    }
    private let banner = MessageBanner.instantiateFromNib()

    public init() { }

    public convenience init(viewController: UIViewController) {
        self.init()
        set(viewController: viewController)
    }

    public func set(viewController: UIViewController) {
        self.viewController = viewController
    }

    public func show(title: String?, message: String?) -> UIAlertController {
        return show(title: title, message: message, actions: [
            AlertAction(title: UITexts.Generic.ok, style: .default, handler: nil)
        ])
    }

    public func show(title: String?, message: String?, actions: [AlertAction]) -> UIAlertController {
        let alert = UIAlertController.create(title: title, message: message, preferredStyle: .alert)

        actions.forEach { alert.addAction($0.action) }
        alert.view.tintColor = KarhooUI.colors.darkGrey

        presentingViewController?.present(alert, animated: true, completion: nil)
        return alert
    }

    public func show(error: KarhooError?) -> UIAlertController {
        let message = error?.localizedMessage ?? UITexts.Errors.noDetailsAvailable
        let alert = UIAlertController.create(title: UITexts.Errors.somethingWentWrong, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: UITexts.Generic.ok, style: .default))
        alert.view.tintColor = KarhooUI.colors.darkGrey

        presentingViewController?.present(alert, animated: true)
        return alert
    }
}
