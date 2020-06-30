//
//  KarhooQuoteSortView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

final class KarhooQuoteSortView: UIView, QuoteSortView {
    
    private weak var actions: QuoteSortViewActions?
    private var segmentedControl: UISegmentedControl!
    private var didSetupConstraints: Bool = false
    
    init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
    }
    
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = "quote_sort_view"
        backgroundColor = .white
        
        let items = [UITexts.Bookings.sortEta, UITexts.Bookings.sortPrice]
        segmentedControl = UISegmentedControl(items: items)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.accessibilityIdentifier = "segment_control"
        segmentedControl.tintColor = KarhooUI.colors.primary
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentControlChanged), for: .valueChanged)
        
        addSubview(segmentedControl)
        
        updateConstraints()
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            let constraints: [NSLayoutConstraint] = [segmentedControl.topAnchor.constraint(equalTo: topAnchor),
                 segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
                 segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0),
                 segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0)]
            
            _ = constraints.map { $0.isActive = true }
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
    func set(actions: QuoteSortViewActions) {
        self.actions = actions
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    @objc
    func segmentControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.actions?.didSelectQuoteOrder(.qta)
        default:
            self.actions?.didSelectQuoteOrder(.price)
        }
    }
}
