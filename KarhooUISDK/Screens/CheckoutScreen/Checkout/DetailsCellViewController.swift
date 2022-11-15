//
//  DetailsCellViewController.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 15/11/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import SwiftUI

class DetailsCellViewController: UIHostingController<DetailsCellView>, DetailsCellViewControllerProtocol {
    
    var onClickAction: (() -> Void)!
    
    init(rootView: DetailsCellView, onClickAction: @escaping () -> Void){
        super.init(rootView: rootView)
        self.onClickAction = onClickAction
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol DetailsCellViewControllerProtocol {
    var onClickAction: (() -> Void)! { get }
}
