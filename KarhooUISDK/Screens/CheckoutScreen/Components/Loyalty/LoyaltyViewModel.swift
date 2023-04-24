//
//  LoyaltyViewModel.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 31/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import Combine
import KarhooSDK
import SwiftUI

class LoyaltyViewModel: ObservableObject {

    // MARK: - Dependencies

    private let worker: LoyaltyWorker

    // MARK: - Properties

    private var cancellables: Set<AnyCancellable> = []

    @Published var error: KarhooLoyaltyError?
    @Published var isBurnModeOn = false {
        didSet {
            updateModeState()
        }
    }
    
    @Published var canEarn: Bool
    @Published var earnAmount: Int
    @Published var balance: Int
    @Published var burnSectionDisabled: Bool
    @Published var canBurn: Bool
    @Published var currency: String
    @Published var tripAmount: Double
    @Published var burnAmount: Int

    @Published var burnOffSubtitle: String
    @Published var burnTitleTextColor: Color
    @Published var burnContentTextColor: Color
    
    var shouldShowView: Bool { worker.isLoyaltyEnabled }

    // MARK: - Lifecycle

    init(worker: LoyaltyWorker = KarhooLoyaltyWorker.shared) {
        self.worker = worker
        self.currency = ""
        self.tripAmount = 0
        self.canEarn = false
        self.canBurn = false
        self.burnSectionDisabled = false
        self.burnAmount = 0
        self.earnAmount = 0
        self.balance = 0
        
        self.burnOffSubtitle = UITexts.Loyalty.burnOffSubtitle
        self.burnTitleTextColor = Color(KarhooUI.colors.text)
        self.burnContentTextColor = Color(KarhooUI.colors.textLabel)
        
        subscribe()
    }

    // MARK: - Private methods
    
    private func subscribe() {
        worker.modelSubject
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let model, _):
                    self?.update(withModel: model)
                case .failure(let error, _):
                    if let error = error {
                        self?.handleError(error)
                    }
                @unknown default:
                    return
                }
            })
            .store(in: &cancellables)
    }
    
    private func update(withModel model: LoyaltyUIModel?) {
        guard let model else { return }
        balance = model.balance
        earnAmount = isBurnModeOn ? 0 : model.earnAmount
        canEarn = model.canEarn
        currency = model.currency
        tripAmount = model.tripAmount
        burnAmount = model.burnAmount
        canBurn = model.canBurn
    }

    private func handleError(_ error: KarhooError) {
        if let loyaltyError = error as? KarhooLoyaltyError {
            switch loyaltyError {
            case .insufficientBalance:
                self.burnSectionDisabled = true
                self.burnOffSubtitle = UITexts.Errors.insufficientBalanceForLoyaltyBurning
                self.burnTitleTextColor = Color(KarhooUI.colors.text).opacity(UIConstants.Alpha.overlay)
                self.burnContentTextColor = Color(KarhooUI.colors.textLabel).opacity(UIConstants.Alpha.overlay)
            default:
                self.burnSectionDisabled = false
                self.error = loyaltyError
            }
        } else {
            self.burnSectionDisabled = false
            self.error = .unknownError
        }
    }
    
    private func updateModeState() {
        if isBurnModeOn && canBurn {
            worker.modeSubject.send(.burn)
        } else if canEarn {
            worker.modeSubject.send(.earn)
        } else {
            worker.modeSubject.send(.none)
        }
    }
}
