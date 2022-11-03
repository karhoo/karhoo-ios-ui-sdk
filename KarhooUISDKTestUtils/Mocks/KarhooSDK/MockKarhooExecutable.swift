//
//  MockKarhooExecutable.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

public class MockExecutable: KarhooExecutable {
    public func execute<T: Codable>(callback: @escaping CallbackClosure<T>) {}
    public func cancel() {}
}
