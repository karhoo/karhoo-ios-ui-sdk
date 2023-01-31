//
//  LoyaltyEarnBurnView.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 23/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI
import Combine

struct LoyaltyEarnBurnView: View {
    
    @ObservedObject var viewModel: NewLoyaltyViewModel

    @State var burnOnInfo = UITexts.Loyalty.info
        
    var body: some View {
        if let error = viewModel.error {
            LoyaltyErrorView(errorMessage: error.text)
                .padding(.top, UIConstants.Spacing.standard)
        } else {
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
                            LoyaltyBurnContent(isToggleOn: $viewModel.isBurnModeOn)
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
        let pointsEarnedText =
        String(format: NSLocalizedString(UITexts.Loyalty.pointsEarnedForTrip, comment: ""), "\(viewModel.earnAmount)")
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
    var currency: String
    var tripAmount: Double
    @Published var canEarn: Bool
    @Published var canBurn: Bool
    var burnAmount: Int
    var earnAmount: Int
    var balance: Int
    
    init(worker: LoyaltyWorker) {
        self.worker = worker
        self.currency = "PLN"
        self.tripAmount = 15.40
        self.canEarn = true
        self.canBurn = true
        self.burnAmount = 1800
        self.earnAmount = 45
        self.balance = 45612
        
        subscribe()
    }
    
    private func subscribe(){
        worker.modelSubject
            .sink(receiveValue: { [weak self] result in
                    switch result {
                    case .success(let model):
                        self?.update(withModel: model)
                    case .failure(let error):
                        return // self?.error = error
                        break
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func update(withModel: LoyaltyViewModel?) {
        // TODO: update values
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
