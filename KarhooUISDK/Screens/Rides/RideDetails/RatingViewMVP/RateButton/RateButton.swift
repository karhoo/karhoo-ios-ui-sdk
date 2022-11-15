//
//  RateButton.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

protocol RateButtonDelegate: AnyObject {
    func didTapRateButton(index: Int)
}

final class RateButton: UIView {
    
    private var rateButton: UIButton!
    private var animationLength: Double = 0.2
    weak var delegate: RateButtonDelegate?
    private var viewModel: RateButtonViewModel = RateButtonViewModel()
    
    init(viewModel: RateButtonViewModel = RateButtonViewModel()) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setUpView()
    }
 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    private func setUpView() {
        
        rateButton = UIButton(type: .custom)
        rateButton.addTarget(self, action: #selector(rateTapped), for: .touchUpInside)
        rateButton.translatesAutoresizingMaskIntoConstraints = false
        rateButton.setImage(viewModel.buttonStates.normal, for: .normal)
        rateButton.setImage(viewModel.buttonStates.selected, for: .selected)
        rateButton.adjustsImageWhenHighlighted = false
        addSubview(rateButton)
        
        _ = [rateButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0),
             rateButton.widthAnchor.constraint(equalToConstant: 30.0),
             rateButton.heightAnchor.constraint(equalToConstant: 30.0),
             rateButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             rateButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             rateButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8.0)].map { $0.isActive = true }
    }
    
    fileprivate func changeSelectedState(_ selected: Bool, _ animated: Bool = true) {
        UIView.transition(with: rateButton,
                          duration: animated ? animationLength : 0.0,
                          options: .transitionCrossDissolve,
                          animations: { self.rateButton.isSelected = selected },
                          completion: nil)
    }
    
    @objc
    private func rateTapped(sender: UIButton) {
        delegate?.didTapRateButton(index: tag)
    }

    func setSelected(_ selected: Bool) {
        changeSelectedState(selected, false)
    }
}
