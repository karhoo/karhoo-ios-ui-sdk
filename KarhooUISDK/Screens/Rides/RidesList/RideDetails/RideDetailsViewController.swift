//
//  BookingDetailsViewController.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

final class RideDetailsViewController: UIViewController, RideDetailsView {

    private var scrollView: UIScrollView!
    private var rideDetailsView: RideDetailsViewContainer!

    private var loadingView: LoadingView!
    
    private let presenter: RideDetailsPresenter
    private var trip: TripInfo?
    private var actionButtonsPresenter: RideDetailsStackButtonPresenter?
    private var cancelRideBehaviour: CancelRideBehaviourProtocol?
    private var tripMetaDataPresenter: TripMetaDataPresenter?
    private let loadingViewAlpha: CGFloat = 0.85
    
    init(presenter: RideDetailsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.setUpView()
    }

    private func setUpView() {
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.accessibilityIdentifier = "scroll_view"
        scrollView.backgroundColor = .white
        
        view.addSubview(scrollView)
        _ = [scrollView.topAnchor.constraint(equalTo: view.topAnchor),
             scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)].map { $0.isActive = true }
        
        rideDetailsView = RideDetailsViewContainer()
        scrollView.addSubview(rideDetailsView)
        _ = [rideDetailsView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10.0),
             rideDetailsView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10.0),
             rideDetailsView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                       constant: -10.0)].map { $0.isActive = true }
        
        loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        
        _ = [loadingView.topAnchor.constraint(equalTo: view.topAnchor),
             loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)].map { $0.isActive = true }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        presenter.bind(view: self)
        loadingView.initialLoadingState()
        loadingView.set(backgroundColor: KarhooUI.colors.darkGrey, alpha: loadingViewAlpha)
        loadingView.set(loadingText: UITexts.Trip.tripCancellingActivityIndicatorText)
        rideDetailsView.tripMetaDataView.delegate = self
    }

    public func showLoading() {
        navigationController?.navigationBar.isHidden = true
        loadingView.show()
    }

    public func hideLoading() {
        self.navigationController?.navigationBar.isHidden = false
        loadingView.hide()
    }

    public func setUpWith(trip: TripInfo,
                          mailComposer: FeedbackEmailComposer) {
        self.trip = trip

        tripMetaDataPresenter = KarhooTripMetaDataPresenter(tripMetaDataActions: self,
                                                            trip: trip,
                                                            tripMetaDataView: rideDetailsView.tripMetaDataView)

        actionButtonsPresenter = RideDetailsStackButtonPresenter(trip: trip,
                                                                 stackButton: rideDetailsView.stackButtonView,
                                                                 mailComposer: mailComposer,
                                                                 rideDetailsStackButtonActions: self)

        let tripDetailsViewModel = TripDetailsViewModel(trip: trip)
        rideDetailsView.tripDetailsView.set(viewModel: tripDetailsViewModel)
        
        tripMetaDataPresenter?.updateFare()
    }

    public func set(navigationTitle: String) {
        self.navigationItem.title = navigationTitle
    }

    func hideFeedbackOptions() {
        rideDetailsView.tripMetaDataView.hideRatingOptions()
    }

    final class KarhooRideDetailsScreenBuilder: RideDetailsScreenBuilder {
        func buildRideDetailsScreen(trip: TripInfo,
                                    callback: @escaping ScreenResultCallback<RideDetailsAction>) -> Screen {

            let mailComposer = KarhooFeedbackEmailComposer()
            let rideDetailsPresenter = KarhooRideDetailsPresenter(trip: trip,
                                                                  mailComposer: mailComposer,
                                                                  callback: callback)

            let rideDetailsViewController = RideDetailsViewController(presenter: rideDetailsPresenter)
            mailComposer.set(parent: rideDetailsViewController)

            let alertHandler = AlertHandler(viewController: rideDetailsViewController)
            let cancelRideBehaviour = CancelRideBehaviour(trip: trip,
                                                          alertHandler: alertHandler)
            rideDetailsPresenter.set(cancelRideBehaviour: cancelRideBehaviour)

            return rideDetailsViewController
        }

        func buildOverlayRideDetailsScreen(trip: TripInfo,
                                           callback: @escaping ScreenResultCallback<RideDetailsAction>) -> Screen {
            let rideDetailsViewController = buildRideDetailsScreen(trip: trip,
                                                                   callback: callback)

            return embedInNavigationController(rideDetailsViewController,
                                               closeCallback: callback)
        }

        private
        func embedInNavigationController(_ vc: UIViewController,
                                         closeCallback: @escaping ScreenResultCallback<RideDetailsAction>) -> Screen {
            let navigationController = UINavigationController(rootViewController: vc)
            let closeButton = CloseBarButton {
                closeCallback(.cancelled(byUser: true))
            }
            closeButton.tintColor = KarhooUI.colors.darkGrey
            vc.navigationItem.rightBarButtonItem = closeButton
            navigationController.navigationBar.tintColor = KarhooUI.colors.darkGrey

            return navigationController
        }
    }
}

extension RideDetailsViewController: RideDetailsStackButtonActions {
    func hideRideOptions() {
        rideDetailsView.stackButtonView.isHidden = true
    }

    func cancelRide() {
        presenter.didPressCancelTrip()
    }

    func trackRide() {
        presenter.didPressTrackTrip()
    }

    func rebookRide() {
        presenter.didPressRebookTrip()
    }

    func reportIssueError() {
        showAlert(title: UITexts.Generic.error,
                  message: UITexts.Generic.noMailSetUpMessage)
    }
}

extension RideDetailsViewController: TripMetaDataActions {

    func showBaseFareDialog() {
        presenter.didPressBaseFareExplanation()
    }
}

extension RideDetailsViewController: TripMetaDataViewDelegate {
    
    func didRateTrip(_ rate: Int) {
        presenter.sendTripRate(rating: rate)
        rideDetailsView.updateViewLayers()
    }

    func didSelectFeedback() {
        presenter.didPressTripFeedback()
    }
}
