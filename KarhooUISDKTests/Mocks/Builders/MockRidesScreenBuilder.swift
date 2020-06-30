//
//  MockRidesScreenBuilder.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

final class MockRidesScreenBuilder: RidesScreenBuilder {

    private var completion: ScreenResultCallback<RidesListAction>?
    let returnViewController = UIViewController()
    func buildRidesScreen(completion: @escaping ScreenResultCallback<RidesListAction>) -> Screen {
        self.completion = completion
        return returnViewController
    }

    func triggerRidesScreenResult(_ result: ScreenResult<RidesListAction>) {
        self.completion?(result)
    }
}
