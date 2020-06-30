//
//  MockKarhooExecutable.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

class MockExecutable: KarhooExecutable {
    func execute<T: Codable>(callback: @escaping CallbackClosure<T>) {}
    func cancel() {}
}
