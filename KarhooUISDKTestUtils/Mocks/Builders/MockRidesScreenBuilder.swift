//
//  MockRidesScreenBuilder.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
import Foundation
@testable import KarhooUISDK

final public class MockRidesScreenBuilder: RidesScreenBuilder {
    public init() {}

    private var completion: ScreenResultCallback<RidesListAction>?
    public let returnViewController = UIViewController()
    public func buildRidesScreen(completion: @escaping ScreenResultCallback<RidesListAction>) -> Screen {
        self.completion = completion
        return returnViewController
    }

    public func triggerRidesScreenResult(_ result: ScreenResult<RidesListAction>) {
        self.completion?(result)
    }
}
