//
//  NewCheckout+MVPC.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 05/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import SwiftUI

protocol NewCheckoutCoordinator: KarhooUISDKSceneCoordinator {

}

protocol NewCheckoutViewController: BaseViewController {
    func setupBinding(_ presenter: any NewCheckoutPresenter)
}

protocol NewCheckoutPresenter: AnyObject {
    func viewDidLoad()
}

protocol NewCheckoutRouter: AnyObject {
}
