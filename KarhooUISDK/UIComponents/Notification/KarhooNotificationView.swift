//
//  KarhooNotificationView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

public struct KHNotificationsViewID {
    public static let titleLabel = "title_label"
}

public final class KarhooNotificationView: UIView, NotificationView {

    private var titleLabel: LinkLabel!
    private var hasBottomInset: Bool

    init(hasBottomInset: Bool = false) {
        self.hasBottomInset = hasBottomInset
        super.init(frame: .zero)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = "notification_view"
        
        // Using text color until the view is rewritten
        backgroundColor = KarhooUI.colors.text
        
        titleLabel = LinkLabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityIdentifier = KHNotificationsViewID.titleLabel
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.baselineAdjustment = .alignBaselines
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textColor = .white
        titleLabel.font = KarhooUI.fonts.captionBold()
        addSubview(titleLabel)
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        let bottomInset: CGFloat = 10.0 + safeAreaInsets.bottom + 50.0
        _ = [titleLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 28.0),
             titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
             titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
             titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                constant: -bottomInset)].map {  $0.isActive = true }
    }
    
    public func change(title: String?) {
        if let label = titleLabel {
            UIView.transition(with: label,
                              duration: 0.50,
                              options: [.curveEaseInOut, .transitionCrossDissolve],
                              animations: {
                                label.text = title
            },
                              completion: nil)
        }
    }

    public func change(title: NSAttributedString) {
        titleLabel?.attributedText = title
    }

    public func addLink(_ link: String, callback: @escaping (() -> Void)) {

        titleLabel?.onCharacterTapped = { label, range in
            guard let ranges = label.attributedText?.matchesForString(link) else {
                return
            }
            let itemsFound = ranges.map { $0.range }.filter { $0.contains(range) }.count
            if itemsFound > 0 {
                callback()
            }
        }
    }
}
