//
//  PhoneNumberCaller.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import UIKit

public protocol PhoneNumberCallerProtocol {
    func call(number: String)
}

public struct PhoneNumberCaller: PhoneNumberCallerProtocol {
    private let urlOpener: URLOpener

    public init(urlOpener: URLOpener = KarhooURLOpener()) {
        self.urlOpener = urlOpener
    }

    public func call(number: String) {
        let cleanNumber = number.replacingOccurrences(of: " ", with: "")
        guard let url = URL(string: "telprompt://\(cleanNumber)") else {
            return
        }

        urlOpener.open(url)
    }
}
