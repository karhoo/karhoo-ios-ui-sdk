//
//  TimePriceMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol TimePriceView {
    func set(actions: TimePriceViewDelegate)
    func set(price: String?)
    func setPrebookMode(timeString: String?, dateString: String?)
    func setAsapMode(qta: String?)
    func set(baseFareHidden: Bool)
    func set(quoteType: String)
    func set(fareExplanationHidden: Bool)
}

protocol TimePriceViewDelegate: AnyObject {
    func didPressFareExplanation()
}
