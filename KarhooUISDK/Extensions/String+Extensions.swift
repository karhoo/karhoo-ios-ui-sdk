
//
//  String+Extensions.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//
import Foundation

extension String {

    var isWhitespace: Bool {
        replacingOccurrences(of: " ", with: "").isEmpty
    }
}
