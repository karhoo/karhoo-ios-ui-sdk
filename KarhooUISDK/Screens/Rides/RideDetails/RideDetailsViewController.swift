//
//  RideDetailsViewController.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import KarhooSDK
import UIKit

final class RideDetailsViewController: UIViewController, RideDetailsView {

    // MARK: - Properties
    
    private let presenter: RideDetailsPresenter
    private var trip: TripInfo?
    private var actionButtonsPresenter: RideDetailsStackButtonPresenter?
    private var cancelRideBehaviour: CancelRideBehaviourProtocol?
    private var tripMetaDataPresenter: TripMetaDataPresenter?
    private let loadingViewAlpha: CGFloat = 0.85

    // MARK: Views

    private lazy var scrollView = UIScrollView().then { scrollView in
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.accessibilityIdentifier = "scroll_view"
        scrollView.backgroundColor = .white
    }
    private lazy var rideDetailsView = RideDetailsViewContainer()
    private lazy var trackDriverButton = MainActionButton().then {
        $0.setTitle(UITexts.Bookings.trackDriver.uppercased(), for: .normal)
        $0.addTarget(self, action: #selector(trackDriverTapped), for: .touchUpInside)
    }
    private lazy var loadingView = LoadingView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Lifecycle

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

    public override func viewDidLoad() {
        super.viewDidLoad()
        presenter.bind(view: self)
        loadingView.initialLoadingState()
        // Using text color until the view is rewritten
        loadingView.set(backgroundColor: KarhooUI.colors.text, alpha: loadingViewAlpha)
        loadingView.set(loadingText: UITexts.Trip.tripCancellingActivityIndicatorText)
        rideDetailsView.tripMetaDataView.delegate = self
        forceLightMode()
    }

    // MARK: - Setup

    private func setUpView() {
        setupHierarchy()
        setupLayout()
    }

    private func setupHierarchy() {
        view.addSubview(scrollView)
        view.addSubview(loadingView)
        view.addSubview(trackDriverButton)
        scrollView.addSubview(rideDetailsView)
    }
    
    private func setupLayout() {
        scrollView.anchorToSuperview()
        loadingView.anchorToSuperview()

        rideDetailsView.anchor(
            top: scrollView.topAnchor,
            leading: scrollView.leadingAnchor,
            trailing: scrollView.trailingAnchor,
            paddingTop: UIConstants.Spacing.medium,
            paddingLeft: UIConstants.Spacing.medium,
            paddingRight: UIConstants.Spacing.medium
        )

        trackDriverButton.anchor(
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            paddingLeft: UIConstants.Spacing.standard,
            paddingRight: UIConstants.Spacing.standard,
            paddingBottom: UIConstants.Spacing.standard
        )
    }

    // MARK: - Methods

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

    func setTrackButtonVisible(_ isVisible: Bool) {
        trackDriverButton.isHidden = !isVisible
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
            rideDetailsPresenter.set(cancelRideBehaviour: cancelRideBehaviour, alertHandler: alertHandler)

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
            let navigationController = NavigationController(rootViewController: vc, style: .secondary)
            let closeButton = CloseBarButton {
                closeCallback(.cancelled(byUser: true))
            }
            closeButton.tintColor = KarhooUI.colors.text
            vc.navigationItem.rightBarButtonItem = closeButton
            navigationController.navigationBar.tintColor = KarhooUI.colors.text

            return navigationController
        }
    }

    // MARK: - UI Actions

    @objc
    private func trackDriverTapped(_ sender: MainActionButton) {
        presenter.didPressTrackTrip()
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
                  message: UITexts.Generic.noMailSetUpMessage,
                  error: nil)
    }

    func contactFleet(_ phoneNumber: String) {
        presenter.didPressContactFleet(phoneNumber)
    }

    func contactDriver(_ phoneNumber: String) {
        presenter.didPressContactDriver(phoneNumber)
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
