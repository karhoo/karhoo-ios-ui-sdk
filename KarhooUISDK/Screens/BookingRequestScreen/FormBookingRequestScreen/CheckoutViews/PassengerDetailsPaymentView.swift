//
//  PassengerDetailsPaymentView.swift
//  KarhooUISDK
//
//  Created by Anca Feurdean on 12.08.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit
import KarhooSDK

public struct KHPassengerDetailsPaymentViewID {
    public static let container = "passenger_details_payment_container"
    public static let passengerDetailsPaymentStackView = "passenger_details_payment_stack_view"
    public static let passengerDetailsContainer = "passenger_details_container"
    public static let passengerPaymentContainer = "passenger_payment_container"
}

final class PassengerDetailsPaymentView: UIView {
    
    private var didSetupConstraints: Bool = false
    var baseViewController: BaseViewController!
    var details: PassengerDetails? {
        didSet {
            passengerDetailsContainer.set(details: details)
        }
    }

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.accessibilityIdentifier = KHPassengerDetailsPaymentViewID.passengerDetailsPaymentStackView
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16.0
        
        return stackView
    }()
    
    private lazy var passengerDetailsContainer: AddPassengerView = {
        let passengerDetailsView = KarhooAddPassengerDetailsView()
        passengerDetailsView.accessibilityIdentifier = KHPassengerDetailsPaymentViewID.passengerDetailsContainer
        passengerDetailsView.setBaseViewController(baseViewController)
        return passengerDetailsView
    }()
    
    private lazy var passengerPaymentContainer: PaymentView = {
        let passengerPaymentView = KarhooAddCardView()
        passengerPaymentView.accessibilityIdentifier = KHPassengerDetailsPaymentViewID.passengerPaymentContainer
        passengerPaymentView.setBaseViewController(baseViewController)
        return passengerPaymentView
    }()
    
    init(baseVC: BaseViewController) {
        super.init(frame: .zero)
        self.baseViewController = baseVC
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHPassengerDetailsPaymentViewID.container
        
        addSubview(stackView)
        
        stackView.addArrangedSubview(passengerDetailsContainer)
        stackView.addArrangedSubview(passengerPaymentContainer)
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            stackView.anchor(top: topAnchor,
                             leading: leadingAnchor,
                             trailing: trailingAnchor,
                             height: 92.0)
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
}
