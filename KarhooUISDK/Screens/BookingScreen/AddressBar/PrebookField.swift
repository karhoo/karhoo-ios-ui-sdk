//
//  PrebookField.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import UIKit

@objc
protocol PreebookFieldDelegate {
    func clearedPrebook()
    func prebookSelected()
}

class PrebookField: NibLoadableView {

    @IBOutlet private weak var timeLabel: UILabel?
    @IBOutlet private weak var dateLabel: UILabel?
    @IBOutlet private weak var timeDateView: UIView?
    @IBOutlet private weak var defaultView: UIView?

    private weak var delegate: PreebookFieldDelegate?

    func set(delegate: PreebookFieldDelegate?) {
        self.delegate = delegate
    }

    @IBAction private func clearPressed(_ sender: Any) {
        delegate?.clearedPrebook()
    }

    @IBAction private func prebookPressed(_ sender: Any) {
        delegate?.prebookSelected()
    }

    func set(date: String, time: String?) {
        timeDateView?.isHidden = false
        defaultView?.isHidden = true
        dateLabel?.text = date
        timeLabel?.text = time
    }

    func showDefaultView() {
        timeDateView?.isHidden = true
        defaultView?.isHidden = false
    }
}
