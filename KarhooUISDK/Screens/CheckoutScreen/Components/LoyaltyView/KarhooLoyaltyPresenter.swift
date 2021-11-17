//
//  KarhooLoyaltyPresenter.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 16.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooLoyaltyPresenter: LoyaltyPresenter {
    var delegate: LoyaltyViewDelegate?
    var view: LoyaltyView?
    var request: LoyaltyViewRequest?
    var earnAmount = 0
    var burnAmount = 0
    
    private var currentMode: LoyaltyMode = .earn {
        didSet {
            view?.set(mode: currentMode, withSubtitle: getSubtitleText())
        }
    }
    
    init(view: LoyaltyView, request: LoyaltyViewRequest) {
        self.view = view
        self.request = request
    }
    
    func getCurrentMode() -> LoyaltyMode {
        return currentMode
    }
    
    func updateEarnedPoints() {}
    
    func updateBurnedPoints() {}
    
    func updateLoyaltyMode(with mode: LoyaltyMode) {
        currentMode = mode
    }
    
    private func getSubtitleText() -> String {
        switch currentMode {
        case .burn:
            return String(format: NSLocalizedString(UITexts.Loyalty.pointsBurnedForTrip, comment: ""), "\(burnAmount)")
        case .earn:
            return String(format: NSLocalizedString(UITexts.Loyalty.pointsEarnedForTrip, comment: ""), "\(earnAmount)")
        }
    }
}
