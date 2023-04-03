//
//  KarhooRidePlanningView.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 31.03.2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct KarhooRidePlanningView: View {
    var body: some View {
//        ZStack(alignment: .bottom) {
//            RepresentedMapView().frame(maxWidth: .infinity, maxHeight: .infinity)
            HStack(spacing: 20) {
                Spacer()
                
                Button("Now") {
                    print("Now tapped")
                }
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .foregroundColor(.white)
                .allowsHitTesting(true)
                
                Spacer()
                
                Button("Later") {
                    print("Later tapped")
                }
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .foregroundColor(.white)
                
                Spacer()
            }
            .padding(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
            .background(Color(KarhooUI.colors.background1))
//        }
    }
}

struct KarhooRidePlanningView_Previews: PreviewProvider {
    static var previews: some View {
        KarhooRidePlanningView()
    }
}

/// This approach works fine, but may pose some issues when we'll want to show the allocation screen and all the other items that we'll not be rewriting at this time. Surest way to go would be working with the map as a UIView insinde a UIViewController and adding the new view for the address picker and "now" and "later" buttons as a UIHostingViewController on top of the KarhooMKMapView.
// struct RepresentedMapView: UIViewRepresentable {
//    typealias UIViewType = KarhooMKMapView
//    private var mapPresenter: BookingMapPresenter = KarhooBookingMapPresenter()
//
//    func makeUIView(context: Context) -> KarhooMKMapView {
//        let myView = KarhooMKMapView()
//        return myView
//    }
//
//    func updateUIView(_ uiView: KarhooMKMapView, context: Context) {
//        setupMapView(uiView, reverseGeolocate: getJourneyDetails() == nil)
//    }
//
//    private func setupMapView(_ mapView: KarhooMKMapView, reverseGeolocate: Bool) {
//        mapPresenter.load(
//            map: mapView,
//            reverseGeolocate: reverseGeolocate,
//            onLocationPermissionDenied: { // [weak self] in
//                // Do not show pop up when allocation view is visible
////                guard self?.tripAllocationView.alpha != 1 else {
////                    return
////                }
////                self?.showNoLocationPermissionsPopUp()
//            }
//        )
//        mapView.set(presenter: mapPresenter)
//    }
//
//    private func getJourneyDetails() -> JourneyDetails? {
//        return KarhooJourneyDetailsManager.shared.getJourneyDetails()
//    }
// }
