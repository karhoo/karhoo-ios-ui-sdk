//
//  SeparatorView.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 21/03/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit

class SeparatorView: UIView {

    init(fixedHeight: CGFloat? = nil, fixedWidth: CGFloat? = nil) {
        super.init(frame: .zero)
        self.setup(height: fixedHeight, width: fixedWidth)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    private func setup(height: CGFloat? = nil, width: CGFloat? = nil) {
        anchor(width: width, height: height)
    }
}
