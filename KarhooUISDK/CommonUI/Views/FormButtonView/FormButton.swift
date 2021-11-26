//
//  FormButton.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

private enum ButtonMode {
    case enabled
    case disabled
}

protocol FormButtonDelegate: class {
    func formButtonPressed()
}

class FormButton: NibLoadableView {

    @IBOutlet weak private var backgroundView: UIView?
    @IBOutlet private weak var button: UIButton?

    private var buttonMode: ButtonMode?
    weak var delegate: FormButtonDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setDisabledMode()
    }

    @IBAction func buttonPressed(_ sender: Any) {
        if buttonMode == .enabled {
            delegate?.formButtonPressed()
        }
    }

    func set(title: String?) {
        button?.setTitle(title, for: .normal)
    }

    func setDisabledMode() {
        buttonMode = .disabled
        backgroundView?.isHidden = true
        button?.isUserInteractionEnabled = false
        button?.isEnabled = false
    }

    func setEnabledMode() {
        buttonMode = .enabled
        backgroundView?.isHidden = false
        button?.isUserInteractionEnabled = true
        button?.isEnabled = true
    }

    func show() {
        self.alpha = 1.0
    }

    func hide() {
        self.alpha = 0.0
    }
}
