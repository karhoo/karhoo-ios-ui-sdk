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
    private var didSetupConstraints: Bool = false

    private lazy var segmentedControl: UISegmentedControl = {
        let items = [UITexts.Bookings.sortEta, UITexts.Bookings.sortPrice]
        let control = UISegmentedControl(items: items)
        control.accessibilityIdentifier = "segment_control"
        control.tintColor = KarhooUI.colors.primary
        control.selectedSegmentIndex = 0
        if #available(iOS 13.0, *) {
            control.selectedSegmentTintColor = KarhooUI.colors.accent
            control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
        }
        control.addTarget(self, action: #selector(segmentControlChanged), for: .valueChanged)

        return control
    }()

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

        addSubview(segmentedControl)
        segmentedControl.pinEdges(to: self, spacing: 8)
    }

    func set(actions: QuoteSortViewActions) {
        self.actions = actions
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

    func setDisabled() {
        isUserInteractionEnabled = false
        alpha = UIConstants.Alpha.disabled
    }

    func setEnabled() {
        isUserInteractionEnabled = true
        alpha = UIConstants.Alpha.enabled
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
