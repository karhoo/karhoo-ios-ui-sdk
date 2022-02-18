//
//  CloseBarButton.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

public final class CloseBarButton: UIBarButtonItem {
    private let callback: () -> Void
    public init(callback: @escaping () -> Void) {
        self.callback = callback
        super.init()
        self.image = UIImage.uisdkImage("cross")
        self.target = self
        self.action = #selector(pressed(sender:))
        self.tintColor = KarhooUI.colors.text
        self.accessibilityIdentifier = "close-button"
        self.accessibilityLabel = UITexts.Generic.close
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func pressed(sender: UIBarButtonItem) {
        callback()
    }
}
