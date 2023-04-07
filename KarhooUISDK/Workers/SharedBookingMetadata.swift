//
//  SharedBookingMetadata.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 05.04.2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation

class BookingMetadata {
    static let shared = BookingMetadata()

    private var metadata: [String: Any]?
    
    func getMetadata() -> [String: Any]? {
        return metadata
    }

    func set(metadata: [String: Any]?) {
        self.metadata = metadata
    }
    
    func reset() {
        metadata = nil
    }
}
