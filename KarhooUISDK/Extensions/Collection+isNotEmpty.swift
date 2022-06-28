//
//  Collection+isNotEmpty.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 26/01/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

extension Collection {
    var isNotEmpty: Bool {
        !self.isEmpty
    }
}
