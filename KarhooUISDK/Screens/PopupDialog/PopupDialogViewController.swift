//
//  PopupDialogViewController.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

final class PopupDialogViewController: UIViewController, PopupDialogView {

    @IBOutlet private weak var formButton: FormButton?
    @IBOutlet private var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet private weak var blurView: UIVisualEffectView?
    @IBOutlet private weak var titleLabel: UILabel?

    @IBOutlet private weak var messageLabel: UILabel?
    private let presenter: KarhooPopupDialogPresenter

    init(presenter: KarhooPopupDialogPresenter) {
        self.presenter = presenter
        super.init(nibName: "PopupDialogViewController", bundle: .current)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        formButton?.delegate = self
        formButton?.setEnabledMode()
        presenter.load(view: self)
        forceLightMode()
    }

    func set(dialogMessage: String) {
        messageLabel?.text = dialogMessage
    }

    func set(formButtonTitle: String) {
        formButton?.set(title: formButtonTitle)
    }

    func set(dialogTitle: String) {
        titleLabel?.text = dialogTitle
    }

    @IBAction func didTapBackground(_ sender: Any) {
        presenter.didTapScreen()
    }

    final class KarhooPopupDialogScreenBuilder: PopupDialogScreenBuilder {
        init() { }

        public func buildPopupDialogScreen(callback: @escaping ScreenResultCallback<Void>) -> Screen {
            let popupDialogPresenter = KarhooPopupDialogPresenter(callback: callback)
            let popupViewController = PopupDialogViewController(presenter: popupDialogPresenter)

            return popupViewController
        }
    }
}

extension PopupDialogViewController: FormButtonDelegate {
    func formButtonPressed() {
        presenter.didTapPopupButton()
    }
}
