//
//  KarhooEmptyDataSetView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

public struct KHKarhooEmptyDataID {
    public static let emptyMessageLabel = "empty_message_label"
}

final class KarhooEmptyDataSetView: UIView, EmptyDataSetView {

    private var emptyMessageLabel: UILabel!

    init() {
        super.init(frame: .zero)
        setUpView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    private func setUpView() {
        accessibilityIdentifier = "empty_dataSet_view"
        translatesAutoresizingMaskIntoConstraints = false
        
        emptyMessageLabel = UILabel()
        emptyMessageLabel.accessibilityIdentifier = KHKarhooEmptyDataID.emptyMessageLabel
        emptyMessageLabel.textAlignment = .center
        emptyMessageLabel.textColor = KarhooUI.colors.text
        emptyMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emptyMessageLabel)
        
        _ = [emptyMessageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
             emptyMessageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
             emptyMessageLabel.leadingAnchor.constraint(lessThanOrEqualTo: self.leadingAnchor, constant: 20.0),
             emptyMessageLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor,
                                                         constant: -20.0)].map { $0.isActive = true}
    }
    
    public func show(emptyDataSetMessage: String) {
        isHidden = false
        emptyMessageLabel.text = emptyDataSetMessage
    }

    public func hide() {
        isHidden = true
    }

}
