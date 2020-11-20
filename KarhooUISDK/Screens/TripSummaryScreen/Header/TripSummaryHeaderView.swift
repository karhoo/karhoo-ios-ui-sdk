//
//  TripSummaryHeaderView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import UIKit

final class TripSummaryHeaderView: NibLoadableView {

    @IBOutlet private weak var headerLabel: UILabel?

    func set(headerText: String) {
        let attributedString = NSMutableAttributedString(string: headerText)
        attributedString.addAttribute(NSAttributedString.Key.kern,
                                      value: 2,
                                      range: NSRange(location: 0, length: headerText.count))
        headerLabel?.attributedText = attributedString
    }
}
