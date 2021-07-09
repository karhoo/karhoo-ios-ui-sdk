//
//  MapAnnotationViewModelSpec.swift
//  KarhooUISDKTests
//
//  Created by Anca Feurdean on 02.07.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//


import XCTest
import KarhooSDK
import CoreLocation

@testable import KarhooUISDK

class MapAnnotationViewModelSpec: XCTestCase {
    
    var mapAnnotationVM: MapAnnotationViewModel!
    
    private func setupCustomVM(with tag: TripPinTags) {
        mapAnnotationVM = MapAnnotationViewModel(coordinate: .init(), tag: tag)
    }
    
    func testWhenCreatingViewModelForDriverPinShouldHaveCorrectBackgroundIcon() {
        setupCustomVM(with: .driverLocation)
        XCTAssertEqual(UIImage.uisdkImage(PinAsset.driverLocation.rawValue),
                       mapAnnotationVM.backgroundIcon)
    }
    
    func testWhenCreatingViewModelForPickUpPinShouldHaveCorrectForegroundIcon() {
        setupCustomVM(with: .pickup)
        XCTAssertEqual(UIImage.uisdkImage(PinAsset.pickup.rawValue),
                       mapAnnotationVM.foregroundIcon)
    }
    
    func testWhenCreatingViewModelForDestinationPinShouldHaveCorrectForegroundIcon() {
        setupCustomVM(with: .destination)
        XCTAssertEqual(UIImage.uisdkImage(PinAsset.destination.rawValue),
                       mapAnnotationVM.foregroundIcon)
    }

    func testWhenCreatingViewModelForDriverPinShouldHaveNoForegroundIcon() {
        setupCustomVM(with: .driverLocation)
        XCTAssertNil(mapAnnotationVM.foregroundIcon)
    }
    
    func testWhenCreatingViewModelShouldHaveAssignedCoordinates() {
        let testCoordinates = CLLocationCoordinate2D(latitude: 1, longitude: 2)
        let customCoordinatesVM = MapAnnotationViewModel(coordinate: testCoordinates,
                                                         tag: .pickup)
        XCTAssertEqual(testCoordinates, customCoordinatesVM.coordinate)
    }
}
