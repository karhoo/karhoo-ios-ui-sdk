//
//  CountryCodeView.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 10.09.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit

class CountryCodeView: UIView {
    init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    convenience init(viewModel: CountryCodeViewModel) {
        self.init()
        self.set(viewModel: viewModel)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpView()
    }
    
    private func setUpView() {
        backgroundColor = KarhooUI.colors.white
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = "" //KHQuoteViewID.quoteView
    }
    
    func set(viewModel: CountryCodeViewModel) {
    }
    
    func resetView() {
    }
}
