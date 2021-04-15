//
//  Observer+Utils.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

extension Observer {

    static func value(_ closure: @escaping ((ResponseType) -> Void)) -> Observer<ResponseType> {
        let newClosure = { (result: Result<ResponseType>) in
            guard let value = result.successValue() else {
                return
            }
            closure(value)
        }
        return Observer<ResponseType>(newClosure)
    }

    static func error(_ closure: @escaping ((KarhooError?) -> Void)) -> Observer<ResponseType> {
        let newClosure = { (result: Result<ResponseType>) in
            guard result.isSuccess() == false else {
                return
            }
            closure(result.errorValue())
        }
        return Observer<ResponseType>(newClosure)
    }
}
