//
//  MockPassengerDetailsViewController.swift
//  KarhooUISDKTests
//
//  Created by Diana Petrea on 08.09.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit
import KarhooSDK
@testable import KarhooUISDK

final class MockPassengerDetailsViewController: MockBaseViewController, KarhooInputViewDelegate {
    lazy var textField: KarhooTextInputView = {
        let textField = KarhooTextInputView(contentType: .firstname,
                                            isOptional: false,
                                            accessibilityIdentifier: KHPassengerDetailsViewID.firstNameInputView)
        textField.delegate = self
        return textField
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view = UIView()
        self.view.addSubview(textField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    var didBecomeInactiveCalled = false
    func didBecomeInactive(identifier: String) {
        didBecomeInactiveCalled = true
    }
    
    var didBecomeActiveCalled = false
    func didBecomeActive(identifier: String) {
        didBecomeActiveCalled = true
    }
}
