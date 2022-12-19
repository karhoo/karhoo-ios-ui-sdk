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
    
    var onTap: (() -> Void)!
    
    init(rootView: DetailsCellView, onTap: @escaping () -> Void) {
        super.init(rootView: rootView)
        self.onTap = onTap
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol DetailsCellViewControllerProtocol: AnyObject {
    var onTap: (() -> Void)! { get }
}
