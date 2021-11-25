//
//  KarhooTripMetaDataPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

final class KarhooTripMetaDataPresenter: TripMetaDataPresenter {

    private weak var tripMetaDataActions: TripMetaDataActions?
    private let trip: TripInfo
    private let tripMetaDataView: TripMetaDataView
    private var tripMetaDataViewModel: TripMetaDataViewModel!
    private let fareService: FareService

    init(tripMetaDataActions: TripMetaDataActions,
         trip: TripInfo,
         tripMetaDataView: TripMetaDataView,
         fareService: FareService = Karhoo.getFareService()) {
        self.tripMetaDataActions = tripMetaDataActions
        self.trip = trip
        self.tripMetaDataView = tripMetaDataView
        self.fareService = fareService

        tripMetaDataViewModel = TripMetaDataViewModel(trip: trip)

        tripMetaDataView.set(viewModel: tripMetaDataViewModel,
                             presenter: self)
    }
    
    func updateFare() {
        if trip.state == .completed {
            fareService.fareDetails(tripId: trip.tripId).execute { [weak self] response in
                guard let newFare = response.successValue() else { return }
                self?.tripMetaDataViewModel.setFare(newFare)
            }
        }
    }

    func baseFareExplanationPressed() {
        tripMetaDataActions?.showBaseFareDialog()
    }
}
