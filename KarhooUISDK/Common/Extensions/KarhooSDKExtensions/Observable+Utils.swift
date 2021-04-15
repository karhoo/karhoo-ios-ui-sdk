//
//  Observable+Utils.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

extension Observable {

    func subscribe(observer: Observer<ResponseType>?) {
        guard let observer = observer else {
            return
        }
        subscribe(observer: observer)
    }

    func unsubscribe(observer: Observer<ResponseType>?) {
        guard let observer = observer else {
            return
        }
        unsubscribe(observer: observer)
    }
}
