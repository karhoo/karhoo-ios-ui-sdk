//
//  RidesListViewController.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

final class RidesListViewController: UIViewController, RidesListView {

    private var tableView: UITableView!
    private var emptyStateView: EmptyStateView!

    private let presenter: RidesListPresenter
    private weak var ridesListActions: RidesListActions?
    private let reuseIdentifier = "bookinghistorycell"
    private var data: TableData<TripInfo>!
    private var source: TableDataSource<TripInfo>!
    private var delegate: TableDelegate<TripInfo>! // swiftlint:disable:this weak_delegate
    internal var paginationEnabled: Bool

    private let bookButtonHeight: CGFloat = 64

    init(presenter: RidesListPresenter,
         paginationEnabled: Bool) {
        self.paginationEnabled = paginationEnabled
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        self.setUpView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(ridesListActions: RidesListActions) {
        self.ridesListActions = ridesListActions
    }
    
    private func setUpView() {
        data = TableData<TripInfo>()
        source = TableDataSource<TripInfo>(reuseIdentifier: reuseIdentifier, tableData: data)
        delegate = TableDelegate<TripInfo>(tableData: data, paginationEnabled: paginationEnabled)
        
        setUpTable()
        setUpEmptyStateView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        presenter.load(screen: self)
        forceLightMode()
    }

    func set(trips: [TripInfo]) {
        tableView.isHidden = false
        emptyStateView.isHidden = true
        data.setSection(key: "", to: trips)
        tableView.reloadData()
    }

    func setEmptyState(title: String, message: String) {
        tableView.isHidden = true
        emptyStateView.isHidden = false
        emptyStateView.setTitle(title)
        emptyStateView.setMessage(message)
    }

    func trackTrip(_ trip: TripInfo) {
        ridesListActions?.trackTrip(trip)
    }

    func rebookTrip(_ trip: TripInfo) {
        ridesListActions?.rebookTrip(trip)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.load(screen: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        var bottomOffset: CGFloat = 0
        if #available(iOS 11.0, *) {
            bottomOffset = view.safeAreaInsets.bottom
        }
        let offset = bookButtonHeight + bottomOffset
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0,
                                                         width: view.frame.width,
                                                         height: offset))
        
        tableView.scrollIndicatorInsets = .init(top: 0, left: 0, bottom: offset, right: 0)
    }
    
    private func setUpEmptyStateView() {
        emptyStateView = EmptyStateView()
        view.addSubview(emptyStateView)
        _ = [emptyStateView.topAnchor.constraint(equalTo: view.topAnchor),
             emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)].map { $0.isActive = true }
    }

    private func setUpTable() {
        tableView = UITableView()
        tableView.accessibilityIdentifier = "rides-table"
        tableView.isAccessibilityElement = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        _ = [tableView.topAnchor.constraint(equalTo: view.topAnchor),
             tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)].map { $0.isActive = true }
        
        tableView.dataSource = source
        tableView.delegate = delegate
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50.0

        tableView.register(RideCell.self, forCellReuseIdentifier: reuseIdentifier)

        source.set { [weak self] (trip: TripInfo, cell: UITableViewCell, indexPath: IndexPath) in
            guard let cell = cell as? RideCell else {
                return
            }
            let cellViewModel = RideCellViewModel(trip: trip)
            let tripDetailsViewModel = TripDetailsViewModel(trip: trip)
            cell.set(
                viewModel: cellViewModel,
                tripDetailsViewModel: tripDetailsViewModel,
                accessibilityIdentifier: "RideCell_\(indexPath.row + 1)",
                trackTripCallback: { [weak self] trip in
                    self?.ridesListActions?.trackTrip(trip)
                },
                contactFleetCallback: { [weak self] trip, numberToDial in
                    self?.ridesListActions?.contactFleet(trip, number: numberToDial)
                },
                contactDriverCallback: { [weak self] trip, numberToDial in
                    self?.ridesListActions?.contactDriver(trip, number: numberToDial)
                }
            )
        }

        delegate.set(selectionCallback: { [weak self] (trip: TripInfo) in
            self?.showDetail(forTrip: trip)
        })
        
        delegate.set(reachedBottom: { [weak self] _ in
            self?.presenter.requestNewPage()
        })
    }

    private func showDetail(forTrip trip: TripInfo) {
        presenter.rideSelected(trip)
    }

    final class KarhooRidesListScreenBuilder: RidesListScreenBuilder {
        init() {}

        func buildRidesListScreen(sortOrder: ComparisonResult,
                                  tripsProvider: KarhooTripsProvider,
                                  paginationEnabled: Bool) -> Screen {
            let tripSorter = KarhooTripsSorter(sortOrder: sortOrder)
            let ridesListPresenter = KarhooRidesListPresenter(tripsSorter: tripSorter,
                                                              tripsProvider: tripsProvider)

            let ridesListViewController = RidesListViewController(presenter: ridesListPresenter,
                                                                  paginationEnabled: paginationEnabled)

            return ridesListViewController
        }
    }
}
