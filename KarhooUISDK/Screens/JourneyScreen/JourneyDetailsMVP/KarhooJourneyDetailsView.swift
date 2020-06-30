//
//  KarhooJourneyDetailsView.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

final class KarhooJourneyDetailsView: UIView, JourneyDetailsView {

    private weak var actions: JourneyDetailsActions?
    private weak var detailsSuperview: UIView?
    private var presenter: JourneyDetailsPresenter?
    private var journeyDetailsViewModel: JourneyDetailsViewModel?

    // new components
    var journeyInfoView: JourneyInfoView!
    var journeyActionsView: JourneyActionsView!
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

        presenter = KahrooJourneyDetailsPresenter(view: self)

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

        journeyInfoView = JourneyInfoView()
        journeyInfoView.delegate = self
        stackContainer.addArrangedSubview(journeyInfoView)

        _ = [journeyInfoView.leadingAnchor.constraint(equalTo: stackContainer.leadingAnchor),
             journeyInfoView.trailingAnchor.constraint(equalTo: stackContainer.trailingAnchor)]
            .map { $0.isActive = true }

        journeyActionsView = JourneyActionsView()
        journeyActionsView.isHidden = true
        journeyActionsView.alpha = 0.0
        stackContainer.addArrangedSubview(journeyActionsView)

        _ = [journeyActionsView.leadingAnchor.constraint(equalTo: stackContainer.leadingAnchor),
             journeyActionsView.trailingAnchor.constraint(equalTo: stackContainer.trailingAnchor)]
            .map { $0.isActive = true }

        stackContainer.bringSubviewToFront(journeyInfoView)
    }

    private func showAnimation() {
         UIView.animate(withDuration: 0.2,
                              delay: 0,
                              options: .curveEaseInOut,
                              animations: {
            self.journeyActionsView.isHidden = false
            UIView.animate(withDuration: 0.2,
                           delay: 0.05,
                           options: .curveEaseInOut,
                           animations: {
                self.journeyActionsView.alpha =  1
            })
        })
    }

    private func hideAnimation() {

        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.journeyActionsView.alpha =  0
                        UIView.animate(withDuration: 0.2,
                                       delay: 0.05,
                                       options: .curveEaseInOut,
                                       animations: {
                            self.journeyActionsView.isHidden = true
                        })
        })
    }

    func set(actions: JourneyDetailsActions,
             detailsSuperview: UIView) {
        self.actions = actions
        self.detailsSuperview = detailsSuperview

        journeyActionsView.set(actions: self)
    }

    func start(tripId: String) {
        presenter?.startMonitoringTrip(tripId: tripId)
    }

    func stop() {
        presenter?.stopMonitoringTrip()
    }

    func updateViewModel(journeyDetailsViewModel: JourneyDetailsViewModel) {
        self.journeyDetailsViewModel = journeyDetailsViewModel
        journeyInfoView.setDriverName(journeyDetailsViewModel.driverName)
        journeyInfoView.setVehicleDetails(journeyDetailsViewModel.vehicleDescription)
        journeyInfoView.setDriverLicenseNumber(journeyDetailsViewModel.driverRegulatoryLicenseNumber)
        journeyInfoView.setLicensePlateNumber(journeyDetailsViewModel.vehicleLicensePlate)
        journeyInfoView.setDriverImage(journeyDetailsViewModel.driverPhotoUrl,
                                       placeholder: "driverImagePlaceholder")

        let journeyOptionsViewModel = JourneyOptionsViewModel(trip: journeyDetailsViewModel.trip)
        journeyActionsView.set(viewModel: journeyOptionsViewModel)
    }
}

extension KarhooJourneyDetailsView: JourneyOptionsActions {
    func cancelSelected() {
        actions?.cancelTrip()
    }
}

extension KarhooJourneyDetailsView: JourneyInfoViewDelegate {
    func rideOptionsTapped(_ value: Bool) {
        _ = value ? showAnimation() : hideAnimation()
    }

    func driverImageTapped(_ image: UIImage) {
        guard journeyDetailsViewModel?.driverPhotoUrl.isEmpty == false,
            let superView = detailsSuperview,
            let driverImage = journeyInfoView.getDriverImage() else {
            return
        }

        let detailsVC = KarhooDriverDetailsView(driverName: journeyDetailsViewModel?.driverName,
                                                driverImage: driverImage)

        superView.addSubview(detailsVC)
        Constraints.pinEdges(of: detailsVC, to: superView)
        superView.layoutIfNeeded()

        detailsVC.startAnimation(fromSmallImageView: journeyInfoView.getDriverImageObject())
    }
}
