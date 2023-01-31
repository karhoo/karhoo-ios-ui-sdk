//
//  LoyaltyEarnBurnView.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 23/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI
import Combine
import KarhooSDK

struct LoyaltyEarnBurnView: View {
    
    @ObservedObject var viewModel: NewLoyaltyViewModel

    @State var burnOnInfo = UITexts.Loyalty.info
        
    var body: some View {
        if let error = viewModel.error {
            LoyaltyErrorView(errorMessage: error.text)
                .padding(.top, UIConstants.Spacing.standard)
        } else if viewModel.canEarn || viewModel.canBurn {
            VStack {
                LoyaltyContainerWithBalance(balance: viewModel.balance, content: {
                    VStack(alignment: .leading) {
                        if viewModel.canEarn {
                            earnContent
                        }
                        if viewModel.canEarn && viewModel.canBurn {
                            orDivider
                        }
                        if viewModel.canBurn {
                            if viewModel.burnSectionDisabled{
                                Text("disabled")
                            }
                            burnContent
                        }
                    }
                })
                if viewModel.isBurnModeOn {
                    burnInfoView
                }
            }
                .padding(.top, UIConstants.Spacing.standard)
        }
    }
    
    @ViewBuilder
    private var earnContent: some View {
        let pointsEarnedText = String(
            format: NSLocalizedString(UITexts.Loyalty.pointsEarnedForTrip, comment: ""),
            "\(viewModel.earnAmount)"
        )
        
        VStack(alignment: .leading) {
            Text(pointsEarnedText)
                .font(Font(KarhooUI.fonts.bodyRegular()))
                .foregroundColor(Color(KarhooUI.colors.text))
        }
    }
    
    @ViewBuilder
    private var orDivider: some View {
        HStack(spacing: UIConstants.Spacing.medium) {
            Color(KarhooUI.colors.border)
            
                .frame(width: .infinity, height: UIConstants.Dimension.Border.standardWidth)
            Text(UITexts.Loyalty.or.uppercased())
                .font(Font(KarhooUI.fonts.bodyBold()))
                .foregroundColor(Color(KarhooUI.colors.textLabel))
            Color(KarhooUI.colors.border)
                .frame(width: .infinity, height: UIConstants.Dimension.Border.standardWidth)
        }
    }
    
    @ViewBuilder
    private var burnContent: some View {
        let burnOffSubtitle = UITexts.Loyalty.burnOffSubtitle
        let burnOnSubtitle = String(
            format: NSLocalizedString(UITexts.Loyalty.burnOnSubtitle, comment: ""),
            "\(viewModel.currency)",
            "\(viewModel.burnAmount)"
        )
        
        
        HStack {
            VStack(alignment: .leading, spacing: UIConstants.Spacing.xSmall) {
                Text(UITexts.Loyalty.burnTitle)
                    .lineLimit(2)
                    .font(Font(KarhooUI.fonts.headerSemibold()))
                    .foregroundColor(Color(KarhooUI.colors.text))
                Text(viewModel.isBurnModeOn ? burnOnSubtitle : burnOffSubtitle)
                    .font(Font(KarhooUI.fonts.bodyRegular()))
                    .foregroundColor(Color(KarhooUI.colors.text))
            }
            .layoutPriority(Double(UILayoutPriority.defaultHigh.rawValue))
            Toggle("", isOn: $viewModel.isBurnModeOn)
                .toggleStyle(SwitchToggleStyle(tint: Color(KarhooUI.colors.secondary)))
        }
    }
    
    @ViewBuilder
    private var burnInfoView: some View {
        HStack {
            Text(burnOnInfo)
                .font(Font(KarhooUI.fonts.bodyRegular()))
                .foregroundColor(Color(KarhooUI.colors.white))
                .padding(.all, UIConstants.Spacing.standard)
            Spacer()
                
        }
            .frame(width: .infinity)
            .background(
                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.small)
                    .fill(Color(KarhooUI.colors.primary))
            )
    }
}

struct LoyaltyEarnBurnView_Previews: PreviewProvider {
    static var previews: some View {
        LoyaltyEarnBurnView(viewModel: NewLoyaltyViewModel(worker: KarhooLoyaltyWorker.shared))
    }
}

class NewLoyaltyViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var error: LoyaltyErrorType? = nil
    @Published var isBurnModeOn = false
    
    let worker: LoyaltyWorker
    
    @Published var canEarn: Bool
    @Published var earnAmount: Int
    @Published var balance: Int

    @Published var burnSectionDisabled: Bool
    @Published var canBurn: Bool
    @Published var currency: String
    @Published var tripAmount: Double
    @Published var burnAmount: Int
    
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
        
        subscribe()
    }
    
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
    
    private func update(withModel model: LoyaltyViewModel?) {
        if let model = model {
            self.balance = model.balance
            self.earnAmount = model.earnAmount
            self.canEarn = model.canEarn
            self.currency = model.currency
            self.tripAmount = model.tripAmount
            self.burnAmount = model.burnAmount
            self.canBurn = model.canBurn
        }
    }
    
    private func handleError(_ error: KarhooError){
        if let loyaltyError = error as? LoyaltyErrorType{
            switch loyaltyError {
            case .insufficientBalance:
                self.burnSectionDisabled = true
            default:
                self.burnSectionDisabled = false
                self.error = loyaltyError
            }
        } else {
            self.burnSectionDisabled = false
            self.error = .unknownError
        }
    }
}

class TempLoyaltyWorker {
    var loyaltyStatusSubject = CurrentValueSubject<LoyaltyViewModel?, LoyaltyErrorType>(nil)
    
    init(){
        loyaltyStatusSubject.send(completion: Subscribers.Completion<LoyaltyErrorType>.failure(.unsupportedCurrency))
    }
}

struct LoyaltyErrorView: View {
    var errorMessage: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(UITexts.Loyalty.title)
                .font(Font(KarhooUI.fonts.headerSemibold()))
                .foregroundColor(Color(KarhooUI.colors.text))
            Text(errorMessage)
                .font(Font(KarhooUI.fonts.bodyBold()))
                .foregroundColor(Color(KarhooUI.colors.textError))
        }
            .padding(.all, UIConstants.Spacing.standard)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .addBorder(Color(KarhooUI.colors.error), cornerRadius: UIConstants.CornerRadius.medium)
            .background(
                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.medium)
                    .fill(Color(KarhooUI.colors.background2))
            )
            .alignmentGuide(VerticalAlignment.center) {
                $0[VerticalAlignment.top]
            }
    }
}
