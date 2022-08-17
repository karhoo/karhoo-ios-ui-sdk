//
//  NotificationMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

public protocol NotificationView {
    func change(title: String?)
    func change(title: NSAttributedString)
    func addLink(_ link: String, callback: @escaping (() -> Void))
}
 
