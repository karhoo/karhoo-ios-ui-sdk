//
//  KarhooRidePlanningView.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 31.03.2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct KarhooRidePlanningView: View {
    @StateObject var viewModel: KarhooRidePlanningViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            RepresentedMapView(
                mapPresenter: KarhooBookingMapPresenter(),
                shouldResetMap: $viewModel.shouldResetMap,
                setupMapViewCompletion: {
                    viewModel.doSomethingOnSetupMapCompleted()
                })
            
            VStack(spacing: 20) {
                RepresentedAddressPicker().frame(width: 400, height: 100)
                
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
            }
            .background(Color(KarhooUI.colors.background1))
        }
    }
}

struct KarhooRidePlanningView_Previews: PreviewProvider {
    static var previews: some View {
        KarhooRidePlanningView(viewModel: KarhooRidePlanningViewModel())
    }
}

struct RepresentedMapView: UIViewRepresentable {
    typealias UIViewType = KarhooMKMapView
    var mapPresenter: BookingMapPresenter = KarhooBookingMapPresenter()
    var shouldResetMap: Binding<Bool>
    var setupMapViewCompletion: () -> Void
    
    func makeUIView(context: Context) -> KarhooMKMapView {
        let myView = KarhooMKMapView()
        setupMapView(myView, reverseGeolocate: getJourneyDetails() == nil)
        return myView
    }

    func updateUIView(_ uiView: KarhooMKMapView, context: Context) {
        if shouldResetMap.wrappedValue {
            mapPresenter.focusMap()
        }
    }

    private func setupMapView(_ mapView: KarhooMKMapView, reverseGeolocate: Bool) {
        mapPresenter.load(
            map: mapView,
            reverseGeolocate: reverseGeolocate,
            onLocationPermissionDenied: {
                self.setupMapViewCompletion()
            }
        )
        mapView.set(presenter: mapPresenter)
    }

    private func getJourneyDetails() -> JourneyDetails? {
        return KarhooJourneyDetailsManager.shared.getJourneyDetails()
    }
}

struct RepresentedAddressPicker: UIViewRepresentable {
    typealias UIViewType = KarhooAddressBarView
    var addressBarPresenter: AddressBarPresenter = BookingAddressBarPresenter()
    
    func makeUIView(context: Context) -> KarhooAddressBarView {
        let myView = KarhooAddressBarView(
            cornerRadious: UIConstants.CornerRadius.large,
            borderLine: true,
            dropShadow: false,
            verticalPadding: 0,
            horizontalPadding: 0,
            hidePickUpDestinationConnector: true,
            hidePrebookButton: true
        )

        myView.set(presenter: addressBarPresenter)
        addressBarPresenter.load(view: myView)
        return myView
    }

    func updateUIView(_ uiView: KarhooAddressBarView, context: Context) {
    }
}
