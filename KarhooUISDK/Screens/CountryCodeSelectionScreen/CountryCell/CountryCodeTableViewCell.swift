//
//  CountryCodeTableViewCell.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 10.09.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit

class CountryCodeTableViewCell: UITableViewCell {

    private var view: CountryCodeView!
    private var didSetupConstraints: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpView()
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
        view = CountryCodeView()
        contentView.addSubview(view)
        
        updateConstraints()
    }

    override func updateConstraints() {
        if !didSetupConstraints {
            view.anchor(top: contentView.topAnchor,
                        leading: contentView.leadingAnchor,
                        trailing: contentView.trailingAnchor,
                        bottom: contentView.bottomAnchor)
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }

    func set(viewModel: CountryCodeViewModel) {
        prepareForReuse()
        view.set(viewModel: viewModel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        view.resetView()
    }
}
