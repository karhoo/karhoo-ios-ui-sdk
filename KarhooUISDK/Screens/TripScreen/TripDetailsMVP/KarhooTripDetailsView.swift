//
//  KarhooTripScreenDetailsView.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
import KarhooSDK

final class KarhooTripScreenDetailsView: UIView, TripScreenDetailsView {

    private weak var actions: TripScreenDetailsActions?
    private weak var detailsSuperview: UIView?
    private var presenter: TripScreenDetailsPresenter?
    private var stackButtonPresenter: RideDetailsStackButtonPresenter?
    private var tripScreenDetailsViewModel: TripScreenDetailsViewModel?

    // new components
    var tripInfoView: TripInfoView!
    var tripActionsView: TripActionsView!
    var stackContainer: UIStackView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setUpView()
    }

    private func setUpView() {

        presenter = KahrooTripScreenDetailsPresenter(view: self)

        translatesAutoresizingMaskIntoConstraints = false

        stackContainer = UIStackView()
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.accessibilityIdentifier = "stack_container"
        stackContainer.axis = .vertical
        stackContainer.spacing = 5.0
        addSubview(stackContainer)

        _ = [stackContainer.topAnchor.constraint(equalTo: self.topAnchor),
             stackContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             stackContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             stackContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor)].map { $0.isActive = true }

        tripInfoView = TripInfoView()
        tripInfoView.delegate = self
        stackContainer.addArrangedSubview(tripInfoView)

        _ = [tripInfoView.leadingAnchor.constraint(equalTo: stackContainer.leadingAnchor),
             tripInfoView.trailingAnchor.constraint(equalTo: stackContainer.trailingAnchor)]
            .map { $0.isActive = true }

        stackContainer.bringSubviewToFront(tripInfoView)
    }

    private func showAnimation() {
         UIView.animate(withDuration: 0.2,
                              delay: 0,
                              options: .curveEaseInOut,
                              animations: {
            self.tripInfoView.stackButtonView.isHidden = false
            UIView.animate(withDuration: 0.2,
                           delay: 0.05,
                           options: .curveEaseInOut,
                           animations: {
                            self.tripInfoView.stackButtonView.alpha =  1
            })
        })
    }

    private func hideAnimation() {

        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.tripInfoView.stackButtonView.alpha =  0
                        UIView.animate(withDuration: 0.2,
                                       delay: 0.05,
                                       options: .curveEaseInOut,
                                       animations: {
                                        self.tripInfoView.stackButtonView.isHidden = true
                        })
        })
    }

    func set(actions: TripScreenDetailsActions,
             detailsSuperview: UIView) {
        self.actions = actions
        self.detailsSuperview = detailsSuperview

//        tripActionsView.set(actions: self)
    }

    func start(tripId: String) {
        presenter?.startMonitoringTrip(tripId: tripId)
    }

    func stop() {
        presenter?.stopMonitoringTrip()
    }

    func updateViewModel(tripDetailsViewModel: TripScreenDetailsViewModel) {
        self.tripScreenDetailsViewModel = tripDetailsViewModel
        tripInfoView.setDriverName(tripDetailsViewModel.driverName)
        tripInfoView.setVehicleDetails(tripDetailsViewModel.vehicleDescription)
        tripInfoView.setDriverLicenseNumber(tripDetailsViewModel.driverRegulatoryLicenseNumber)
        tripInfoView.setLicensePlateNumber(tripDetailsViewModel.vehicleLicensePlate)
        tripInfoView.setDriverImage(tripDetailsViewModel.driverPhotoUrl,
                                       placeholder: "driverImagePlaceholder")

        let tripOptionsViewModel = TripOptionsViewModel(trip: tripDetailsViewModel.trip)
//        tripActionsView.set(viewModel: tripOptionsViewModel)
        stackButtonPresenter = RideDetailsStackButtonPresenter(trip: tripDetailsViewModel.trip,
                                                                 stackButton: tripInfoView.stackButtonView,
//                                                                 mailComposer: mailComposer,
                                                                 mailComposer: nil,
                                                                 rideDetailsStackButtonActions: self)
    }
}

extension KarhooTripScreenDetailsView: TripOptionsActions {
    func cancelSelected() {
        actions?.cancelTrip()
    }
}

extension KarhooTripScreenDetailsView: TripInfoViewDelegate {
    func rideOptionsTapped(_ value: Bool) {
        _ = value ? showAnimation() : hideAnimation()
    }

    func driverImageTapped(_ image: UIImage) {
        guard tripScreenDetailsViewModel?.driverPhotoUrl.isEmpty == false,
            let superView = detailsSuperview,
            let driverImage = tripInfoView.getDriverImage() else {
            return
        }

        let detailsVC = KarhooDriverDetailsView(driverName: tripScreenDetailsViewModel?.driverName,
                                                driverImage: driverImage)

        superView.addSubview(detailsVC)
        Constraints.pinEdges(of: detailsVC, to: superView)
        superView.layoutIfNeeded()

        detailsVC.startAnimation(fromSmallImageView: tripInfoView.getDriverImageObject())
    }
}

extension KarhooTripScreenDetailsView: RideCellStackButtonActions {

    func track(_ trip: TripInfo) {
//        trackTripCallback?(trip)
    }
}

extension KarhooTripScreenDetailsView: RideDetailsStackButtonActions {
    func hideRideOptions() {
        tripInfoView.stackButtonView.isHidden = true
    }

    func cancelRide() {
        actions?.cancelTrip()
    }

    func trackRide() {}

    func rebookRide() {}

    func reportIssueError() {}
}
