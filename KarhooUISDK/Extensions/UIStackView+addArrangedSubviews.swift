//
//  UIStackView+addArrangedSubviews.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 14/03/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import UIKit

extension UIStackView {

    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach {
            addArrangedSubview($0)
        }
    }
}
