//
//  KarhooRidePlanningScreenBuilder.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 04.04.2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

public final class KarhooRidePlanningScreenBuilder: RidePlanningScreenBuilder {

    private let locationService: LocationService

    public init(locationService: LocationService = KarhooLocationService()) {
        self.locationService = locationService
    }
    
    public func buildRidePlanningScreen(
        journeyInfo: JourneyInfo? = nil,
        passengerDetails: PassengerDetails? = nil,
        bookingMetadata: [String: Any]?,
        callback: ScreenResultCallback<KarhooRidePlanningResult>?
    ) -> Screen {
        PassengerInfo.shared.set(details: passengerDetails)
        
        var validatedJourneyInfo: JourneyInfo? {
            guard let origin = journeyInfo?.origin else {
                return nil
            }
            
            var isDateAllowed: Bool {
                guard let injectedDate = journeyInfo?.date else {
                    return false
                }
                return injectedDate >= Date().addingTimeInterval(60*60)
            }
            
            return JourneyInfo(
                origin: origin,
                destination: journeyInfo?.destination,
                date: isDateAllowed ? journeyInfo?.date : nil
            )
        }
        KarhooJourneyDetailsManager.shared.setJourneyInfo(journeyInfo: validatedJourneyInfo)

        let coordinator = KarhooRidePlanningCoordinator(
            navigationController: nil,
            bookingMetadata: bookingMetadata,
            callback: callback!
        )
        
        guard
            let navigationController = coordinator.navigationController,
            let viewController = coordinator.baseViewController as? RidePlanningViewController
        else {
            assertionFailure("Missing navigation in Ride Planning coordinator")
            return UINavigationController()
        }
        
        if let sideMenuRouting = KarhooUI.sideMenuHandler {
            let sideMenu = UISDKScreenRouting
                .default.sideMenu().buildSideMenu(
                    hostViewController: viewController,
                    routing: sideMenuRouting
                )
            viewController.set(sideMenu: sideMenu)
            viewController.set(leftNavigationButton: .menuIcon)
        } else {
            viewController.set(leftNavigationButton: .exitIcon)
        }
        
        navigationController.modalPresentationStyle = .fullScreen
        return navigationController
    }
}
