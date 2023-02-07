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
            updateWorkerState()
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
    @Published var burnContentTextColor: Color
    
    var shouldShowView: Bool { worker.isLoyaltyEnabled }

    // MARK: - Lifecycle

    init(worker: LoyaltyWorker) {
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
        self.burnContentTextColor = Color(KarhooUI.colors.text)
        
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
        if let model = model {
            self.balance = model.balance
            self.earnAmount = model.earnAmount
            self.canEarn = model.canEarn
            self.currency = model.currency
            self.tripAmount = model.tripAmount
            self.burnAmount = model.burnAmount
            self.canBurn = model.canBurn
            if model.canEarn {
                worker.modeSubject.send(.earn)
            }
        }
    }
    
    private func handleError(_ error: KarhooError) {
        if let loyaltyError = error as? KarhooLoyaltyError {
            switch loyaltyError {
            case .insufficientBalance:
                self.burnSectionDisabled = true
                self.burnOffSubtitle = UITexts.Errors.insufficientBalanceForLoyaltyBurning
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
    
    private func updateWorkerState() {
        if isBurnModeOn {
            worker.modeSubject.send(.burn)
        } else if canEarn {
            worker.modeSubject.send(.earn)
        }
    }
}
