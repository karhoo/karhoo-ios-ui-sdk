//
//  PrebookFieldMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol PrebookFieldView {

    func set(date: String, time: String?)

    func showDefaultView()
}

protocol PreebookFieldActions: AnyObject {

    func clearedPrebook()

    func prebookSelected()
    
    func prebookSet()
}
