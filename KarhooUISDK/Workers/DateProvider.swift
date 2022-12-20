//
//  DateProvider.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 08/12/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

protocol DateProvider {
    var now: Date { get }
}

struct KarhooDateProvider: DateProvider {
    var now: Date { Date() }
}
