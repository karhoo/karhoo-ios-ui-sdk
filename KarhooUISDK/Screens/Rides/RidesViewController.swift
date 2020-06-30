//
//  BookingsRootViewController.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

final class RidesViewController: UIViewController, RidesView {

    private let tabAnimationTime: TimeInterval = 0.25
    private let twoPageViewController: TwoPageViewController
    private let presenter: RidesPresenter
    @IBOutlet private weak var upcomingTabLabel: UILabel?
    @IBOutlet private weak var pastTabLabel: UILabel?
    @IBOutlet private weak var tabView: UIView?
    @IBOutlet private weak var childPageView: UIView?
    @IBOutlet private var tabConstraintSwitcher: ResizingSwitcher!

    @IBOutlet private weak var formButton: FormButton?

    init(presenter: RidesPresenter) {
        self.presenter = presenter
        self.twoPageViewController = TwoPageViewController()
        super.init(nibName: "RidesViewController", bundle: .current)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let childPageView = self.childPageView else {
            return
        }

        childPageView.addSubview(twoPageViewController.view)
        Constraints.pinEdges(of: twoPageViewController.view, to: childPageView)
        addChild(twoPageViewController)

        formButton?.delegate = self
        formButton?.set(title: UITexts.Bookings.bookATrip)
        formButton?.setEnabledMode()
        tabConstraintSwitcher.set(animationTime: tabAnimationTime)
        presenter.bind(view: self)
    }

    func set(title: String) {
        self.title = title
    }

    func set(pageViews: [RidesListView]) {
        twoPageViewController.set(delegate: self)

        pageViews.forEach({
            $0.set(ridesListActions: self)
        })

        let viewControllers = pageViews.compactMap { $0 }
        twoPageViewController.set(viewControllers: viewControllers)
    }

    func moveTabToPastBookings() {
        tabConstraintSwitcher.expand(animated: true)
        pastTabLabel?.textColor = KarhooUI.colors.primary
        upcomingTabLabel?.textColor = KarhooUI.colors.medGrey
    }

    func moveTabToUpcomingBookings() {
        tabConstraintSwitcher.contract(animated: true)
        pastTabLabel?.textColor = KarhooUI.colors.medGrey
        upcomingTabLabel?.textColor = KarhooUI.colors.primary
    }

    func set(bookingButtonHidden: Bool) {
        formButton?.isHidden = bookingButtonHidden
    }

    @IBAction private func closePressed() {
        presenter.didPressClose()
    }

    @IBAction func upcomingBookingsPressed() {
        twoPageViewController.switchToFirstTab()
        moveTabToUpcomingBookings()
    }

    @IBAction func pastBookingsPressed() {
        twoPageViewController.switchToSecondTab()
        moveTabToPastBookings()
    }

    final class KarhooRidesScreenBuilder: RidesScreenBuilder {

        init() {}

        func buildRidesScreen(completion: @escaping ScreenResultCallback<RidesListAction>) -> Screen {
            let ridesPresenter = KarhooRidesPresenter(completion: completion)

            let ridesView = RidesViewController(presenter: ridesPresenter)

            let upcomingTripsProvider = KarhooTripsProvider(tripRequestType: .upcoming,
                                                            shouldPoll: true)
            let pastTripsProvider = KarhooTripsProvider(tripRequestType: .past)

            guard let upcomingRidesList = UISDKScreenRouting.default.ridesList()
            .buildRidesListScreen(sortOrder: .orderedAscending,
                                  tripsProvider: upcomingTripsProvider,
                                  paginationEnabled: false) as? RidesListView else {
                    return Screen()
            }

            guard let pastRidesList = UISDKScreenRouting.default.ridesList()
            .buildRidesListScreen(sortOrder: .orderedDescending,
                                  tripsProvider: pastTripsProvider,
                                  paginationEnabled: true) as? RidesListView else {
                    return Screen()
            }

            ridesPresenter.set(pages: [upcomingRidesList, pastRidesList])

            let navigation = embedInNavigationController(ridesView,
                                                         closeCallback: { _ in
                                                            completion(.cancelled(byUser: true)) })
            
            return navigation
        }

        private func embedInNavigationController(_ vc: UIViewController,
                                                 closeCallback: @escaping ScreenResultCallback<Void>) -> Screen {
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

extension RidesViewController: TwoPageControllerDelegate {
    func switchedToPage(index: Int) {
        self.presenter.didSwitchToPage(index: index)
    }
}

extension RidesViewController: FormButtonDelegate {
    func formButtonPressed() {
        self.presenter.didPressRequestTrip()
    }
}

extension RidesViewController: RidesListActions {

    func trackTrip(_ trip: TripInfo) {
        presenter.didPressTrackTrip(trip: trip)
    }

    func rebookTrip(_ trip: TripInfo) {
        presenter.didPressRebookTrip(trip: trip)
    }
}
