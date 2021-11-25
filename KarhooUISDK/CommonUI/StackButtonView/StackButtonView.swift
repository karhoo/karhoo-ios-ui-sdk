//
//  StackButtonView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol StackButtonView: AnyObject {
    func set(buttonText: String, action: @escaping () -> Void)
    func set(firstButtonText: String, firstButtonAction: @escaping () -> Void,
             secondButtonText: String, secondButtonAction: @escaping () -> Void)
}
