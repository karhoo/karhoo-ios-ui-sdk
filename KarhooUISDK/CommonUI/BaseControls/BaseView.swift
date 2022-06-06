//
//  BaseView.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit

public protocol BaseView: UIView {

    func configure(configService: ConfigService)
}

public extension BaseView {

    func configure(configService: ConfigService = Karhoo.getConfigService()) {
        configService.uiConfig(uiConfigRequest: UIConfigRequest(viewId: self.accessibilityIdentifier))
            .execute(callback: { [weak self] result in
            switch result {
            case .success(let model): self?.set(configuration: model)
            case .failure: print("no config for view: \(self?.accessibilityIdentifier ?? "nil" )")
            }
        })
    }

    private func set(configuration: UIConfig) {
        isHidden = configuration.hidden
    }

    var parentViewController: UIViewController? {
           var parentResponder: UIResponder? = self
           while parentResponder != nil {
               parentResponder = parentResponder?.next
               if let viewController = parentResponder as? UIViewController {
                   return viewController
               }
           }
           return nil
       }
}
