//
//  KarhooMKAnnotation.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

final class KarhooMKAnnotation: NSObject, MKAnnotation {
    let backgroundIcon: UIImage
    let icon: UIImage?
    @objc dynamic var coordinate: CLLocationCoordinate2D

    init(coordinate: CLLocationCoordinate2D,
         tag: TripPinTags) {
        self.coordinate = coordinate
        switch tag {
        case .destination:
            backgroundIcon = UIImage.uisdkImage(PinAsset.background.rawValue)
                                    .coloured(withTint: KarhooUI.colors.primary)
            icon = UIImage.uisdkImage(PinAsset.destination.rawValue)
        case .pickup:
            backgroundIcon = UIImage.uisdkImage(PinAsset.background.rawValue)
                                    .coloured(withTint: KarhooUI.colors.secondary)
            icon = UIImage.uisdkImage(PinAsset.pickup.rawValue)
        case .driverLocation:
            icon = nil
            backgroundIcon = UIImage.uisdkImage(PinAsset.driverLocation.rawValue)
        }
    }
}
