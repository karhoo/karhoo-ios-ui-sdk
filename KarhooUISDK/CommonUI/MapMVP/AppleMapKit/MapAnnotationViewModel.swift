//
//  MapAnnotationViewModel.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import CoreLocation
import Foundation
import MapKit

public final class MapAnnotationViewModel: NSObject, MKAnnotation {

    let backgroundIcon: UIImage
    let foregroundIcon: UIImage?
    let tag: TripPinTags
    @objc dynamic public var coordinate: CLLocationCoordinate2D

    init(
        coordinate: CLLocationCoordinate2D,
        tag: TripPinTags
    ) {
        self.coordinate = coordinate
        self.tag = tag
        switch tag {
        case .destination:
            backgroundIcon = UIImage.uisdkImage(PinAsset.background.rawValue)
                                    .coloured(withTint: KarhooUI.colors.secondary)
            foregroundIcon = UIImage.uisdkImage(PinAsset.destination.rawValue)
        case .pickup:
            backgroundIcon = UIImage.uisdkImage(PinAsset.background.rawValue)
                                    .coloured(withTint: KarhooUI.colors.primary)
            foregroundIcon = UIImage.uisdkImage(PinAsset.pickup.rawValue)
        case .driverLocation:
            backgroundIcon = UIImage.uisdkImage(PinAsset.driverLocation.rawValue)
            foregroundIcon = nil
        }
    }
}
