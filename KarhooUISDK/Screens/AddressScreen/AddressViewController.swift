//
//  AddressViewController.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK
import CoreLocation

public struct KHAddressViewID {
    public static let searchBarView = "search_bar"
    public static let googleLogoView = "address_view_google_logo"
    public static let emptyResultsView = "empty_data_set_view"
    public static let backButton = "back-button"
}

final class AddressViewController: UIViewController, AddressView {

    // new components
    private var stackView: UIStackView!
    private var searchBarView: KarhooAddressSearchBar!
    private var setOnMapView: BaseSelectionView!
    private var currentLocationView: BaseSelectionView!
    private var table: UITableView!
    private var emptyResultsView: KarhooEmptyDataSetView!
    private var googleLogoViewBottomConstraint: NSLayoutConstraint!
    private var googleLogoView: AddressGoogleLogoView!
    private let reuseIdentifier = "addressScreenCell"
    private let keyboardSizeProvider: KeyboardSizeProviderProtocol = KeyboardSizeProvider.shared
    private var tableData: TableData<AddressCellViewModel>?
    private var tableDataSource: TableDataSource<AddressCellViewModel>?
    private var tableDelegate: TableDelegate<AddressCellViewModel>? // swiftlint:disable:this weak_delegate
    private let presenter: AddressPresenter
    private var addressMapView: KarhooAddressMapView!

    private lazy var mainContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(presenter: AddressPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardSizeProvider.register(listener: self)
        setupBackButton()
    }
    
    override func loadView() {
        super.loadView()
        setUpView()
    }

    func setupBackButton() {
        let button = UIBarButtonItem(title: UITexts.Generic.cancel,
                                     style: .plain,
                                     target: self,
                                     action: #selector(AddressViewController.close(sender:)))
        button.accessibilityIdentifier = KHAddressViewID.backButton
        button.tintColor = KarhooUI.colors.darkGrey
        navigationItem.leftBarButtonItem = button
    }
    
    private func setUpView() {
        view.backgroundColor = KarhooUI.colors.offWhite
        view.addSubview(mainContainer)

        mainContainer.topAnchor.constraint(equalTo: view.topAnchor,
                                             constant: navigationController!.navigationBar.frame.size.height).isActive = true
        mainContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mainContainer.pinLeftRightEdegs(to: view)

        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5.0
        stackView.axis = .vertical
        mainContainer.addSubview(stackView)

        _ = [stackView.topAnchor.constraint(equalTo: mainContainer.safeAreaLayoutGuide.topAnchor),
             stackView.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
             stackView.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor)].map { $0.isActive = true }
        
        searchBarView = KarhooAddressSearchBar()
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        searchBarView.accessibilityIdentifier = KHAddressViewID.searchBarView
        searchBarView.set(actions: self,
                          addressMode: presenter.addressMode)
        stackView.addArrangedSubview(searchBarView)
        _ = [searchBarView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
             searchBarView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)].map { $0.isActive = true }
        
        setOnMapView = BaseSelectionView(type: .mapPickUp, identifier: "set_on_map_view")
        setOnMapView.delegate = self
        stackView.addArrangedSubview(setOnMapView)
        _ = [setOnMapView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
             setOnMapView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)].map { $0.isActive = true }
        
        currentLocationView = BaseSelectionView(type: .currentLocation, identifier: "current_location_view")
        currentLocationView.delegate = self
        currentLocationView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(currentLocationView)
        _ = [currentLocationView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
             currentLocationView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)].map { $0.isActive = true }
        
        table = UITableView(frame: .zero)
        table.accessibilityIdentifier = "table_view"
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorColor = KarhooUI.colors.offWhite
        table.backgroundColor = KarhooUI.colors.offWhite
        
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 50.0
        table.separatorStyle = .none
        
        mainContainer.addSubview(table)
        _ = [table.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 5.0),
             table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             table.trailingAnchor.constraint(equalTo: view.trailingAnchor)].map { $0.isActive = true }
        
        setupTable()
        
        googleLogoView = AddressGoogleLogoView()
        googleLogoView.translatesAutoresizingMaskIntoConstraints = false
        googleLogoView.accessibilityIdentifier = KHAddressViewID.googleLogoView
        googleLogoView.backgroundColor = KarhooUI.colors.offWhite
            
        mainContainer.addSubview(googleLogoView)
        
        _ = [googleLogoView.topAnchor.constraint(equalTo: table.bottomAnchor),
             googleLogoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             googleLogoView.trailingAnchor.constraint(equalTo: view.trailingAnchor)].map { $0.isActive = true }
        googleLogoViewBottomConstraint = googleLogoView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        googleLogoViewBottomConstraint.isActive = true
        
        emptyResultsView = KarhooEmptyDataSetView()
        emptyResultsView?.accessibilityIdentifier = KHAddressViewID.emptyResultsView
        emptyResultsView.translatesAutoresizingMaskIntoConstraints = false
        mainContainer.addSubview(emptyResultsView)
        
        _ = [emptyResultsView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 5.0),
             emptyResultsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             emptyResultsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             emptyResultsView.bottomAnchor.constraint(equalTo: googleLogoView.topAnchor)].map { $0.isActive = true }

        presenter.checkLocationPermissions()
    }
    
    func disableLocationOptions() {
        setOnMapView.isHidden = true
        currentLocationView.isHidden = true
    }

    func buildAddressMapView() {
        addressMapView = KarhooAddressMapView()
        addressMapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addressMapView)
        addressMapView.isHidden = true

        _ = [addressMapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
             addressMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)].map { $0.isActive = true }
        addressMapView.pinLeftRightEdegs(to: view)

        addressMapView.set(actions: self,
                           addressType: presenter.addressMode)
    }

    deinit {
        keyboardSizeProvider.remove(listener: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        presenter.viewWillShow()
    }

    @objc func close(sender: UIBarButtonItem) {
        _ = searchBarView.resignFirstResponder()
        presenter.close()
    }

    func set(cells: [AddressCellViewModel]) {
        tableData?.clearData()
        
        tableData?.setSection(key: "", to: cells)
        table.reloadData()
    }

    func set(mapPickerIcon: BaseSelectionViewType) {
        setOnMapView.setViewType(mapPickerIcon)
    }
    
    func set(title: String?) {
        navigationItem.title = title
    }

    func clearSearchInputField() {
        searchBarView.clearSearchInputField()
    }

    func showLoadingIndicator() {
        searchBarView.showLoadingIndicator()
    }

    func hideLoadingIndicator() {
        searchBarView.hideLoadingIndicator()
    }

    func focusInputField() {
        searchBarView.focusInputField()
    }

    func unfocusInputField() {
        searchBarView.unfocusInputField()
    }

    func show(emptyDataSetMessage: String) {
        table.isHidden = true
        emptyResultsView?.show(emptyDataSetMessage: emptyDataSetMessage)
    }

    func hideEmptyDataSet() {
        table.isHidden = false
        emptyResultsView?.hide()
    }

    func addressMapViewSelected(_ value: Bool) {
        navigationController?.setNavigationBarHidden(value, animated: true)
        addressMapView.isHidden = !value
        _ = value ? unfocusInputField() : focusInputField()
    }

    private func setupTable() {
        let tableData = TableData<AddressCellViewModel>()

        tableDataSource = TableDataSource(reuseIdentifier: reuseIdentifier,
                                          tableData: tableData)

        let configuration = { [weak self] (address: AddressCellViewModel, cell: UITableViewCell, _: IndexPath) -> Void in
            self?.configure(cell: cell, with: address)
        }

        tableDataSource?.set(cellConfigurationCallback: configuration)

        tableDelegate = TableDelegate(tableData: tableData)

        tableDelegate?.set(selectionCallback: { [weak self] (address: AddressCellViewModel) in
            self?.presenter.selected(address: address)
        })

        table.register(AddressTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

        table.delegate = tableDelegate
        table.dataSource = tableDataSource
        
        table.tableFooterView = UIView()

        self.tableData = tableData

        table.reloadData()
    }

    private func configure(cell: UITableViewCell, with address: AddressCellViewModel) {
        guard let cell = cell as? AddressTableViewCell else {
            return
        }

        cell.set(address: address)
    }

    class KarhooAddressScreenBuilder: AddressScreenBuilder {

        init() {}

        func buildAddressScreen(locationBias: CLLocation?,
                                addressType: AddressType,
                                callback: @escaping ScreenResultCallback<LocationInfo>) -> Screen {
            let presenter = KarhooAddressPresenter(preferredLocation: locationBias,
                                                   addressMode: addressType,
                                                   selectionCallback: callback)
            let view = AddressViewController(presenter: presenter)
            presenter.set(view: view)

            return UINavigationController(rootViewController: view)
        }
    }
}

extension AddressViewController: AddressSearchBarActions {

    func search(text: String?) {
        presenter.search(text: text)
    }

    func clearSearch() {
        presenter.clearSearch()
    }
}

extension AddressViewController: KeyboardListener {

    func keyboard(updatedHeight: CGFloat) {
        googleLogoViewBottomConstraint.constant = -updatedHeight
        view.layoutIfNeeded()
    }
}

extension AddressViewController: AddressMapActions {

    func addressMapSelected(location: LocationInfo) {
        presenter.addressMapViewSelected(location: location)
    }

    func closeAddressMapView() {
        addressMapViewSelected(false)
    }
}

extension AddressViewController: BaseSelectionViewDelegate {
    
    func didSelectView(_ view: BaseSelectionView) {
        switch view.viewType {
        case .mapPickUp, .mapDropOff:
            addressMapViewSelected(true)
        case .currentLocation:
            presenter.getCurrentLocation()
        default:
            print("No type provided. Function: didSelectView:, line: 320")
        }
    }
}
