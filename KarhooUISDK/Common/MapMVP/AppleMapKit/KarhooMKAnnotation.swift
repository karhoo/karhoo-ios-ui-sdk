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

    private(set) var icon: UIImage?
    @objc dynamic var coordinate: CLLocationCoordinate2D

    init(coordinate: CLLocationCoordinate2D,
         icon: UIImage?) {
        self.coordinate = coordinate
        self.icon = icon
    }
}
