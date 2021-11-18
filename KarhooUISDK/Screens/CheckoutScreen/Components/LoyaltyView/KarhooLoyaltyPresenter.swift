//
//  KarhooLoyaltyPresenter.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 16.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class KarhooLoyaltyPresenter: LoyaltyPresenter {
    weak var delegate: LoyaltyViewDelegate?
    var view: LoyaltyView?
    var viewModel: LoyaltyViewModel?
    var earnAmount = 0
    var burnAmount = 0
    
    private var currentMode: LoyaltyMode = .earn {
        didSet {
            view?.set(mode: currentMode, withSubtitle: getSubtitleText())
        }
    }
    
    init(view: LoyaltyView) {
        self.view = view
    }
    
    func getCurrentMode() -> LoyaltyMode {
        return currentMode
    }
    
    func set(viewModel: LoyaltyViewModel) {
        self.viewModel = viewModel
    }
    
    func updateEarnedPoints() {}
    
    func updateBurnedPoints() {}
    
    func updateLoyaltyMode(with mode: LoyaltyMode) {
        currentMode = mode
        delegate?.didToggleLoyaltyMode(newValue: mode)
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
