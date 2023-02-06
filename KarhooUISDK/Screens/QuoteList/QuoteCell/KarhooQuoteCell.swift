//
//  QuoteCell.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

class KarhooQuoteCell: UITableViewCell {
    
    private var quoteView: QuoteView!
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
        backgroundColor = .clear
        selectionStyle = .none
        quoteView = QuoteView()
        contentView.addSubview(quoteView)
        
        updateConstraints()
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
        
            _ = [quoteView.topAnchor.constraint(equalTo: contentView.topAnchor),
                 quoteView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                 quoteView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                 quoteView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)].map { $0.isActive = true }
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }

    func set(viewModel: QuoteViewModel) {
        prepareForReuse()
        quoteView.set(viewModel: viewModel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        quoteView.resetView()
    }
}
