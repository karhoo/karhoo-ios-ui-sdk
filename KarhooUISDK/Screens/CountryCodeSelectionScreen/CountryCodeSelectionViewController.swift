//
//  CountryCodeSelectionViewController.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 10.09.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit

struct KHCountryCodeSelectionViewID {
    static let backButton = "back_button"
    static let tableView = "table_view"
    static let pageTitleLabel = "title_label"
}

final class CountryCodeSelectionViewController: UIViewController {

    private let tableViewReuseIdentifier = "CountryCodeTableViewCell"
    private let sectionKey = 0
    private let delegateKey = ""
    
    private let standardButtonSize: CGFloat = 44.0
    private let standardSpacing: CGFloat = 20.0
    private let extraSmallSpacing: CGFloat = 4.0
    private var presenter: CountryCodeSelectionPresenter
    private var tableViewBottomConstraint: NSLayoutConstraint!
    private let searchController = UISearchController(searchResultsController: nil)
    private let keyboardSizeProvider: KeyboardSizeProviderProtocol = KeyboardSizeProvider.shared
    
    private var data: TableData<Country>!
    private var source: TableDataSource<Country>!
    private var delegate: TableDelegate<Country>! // swiftlint:disable:this weak_delegate
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    private var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    // MARK: - Views and Controls
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = KHCountryCodeSelectionViewID.backButton
        button.tintColor = KarhooUI.colors.darkGrey
        button.setImage(UIImage.uisdkImage("backIcon").withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle(UITexts.Generic.back, for: .normal)
        button.setTitleColor(KarhooUI.colors.darkGrey, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12.0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: extraSmallSpacing, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var pageTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHCountryCodeSelectionViewID.pageTitleLabel
        label.font = KarhooUI.fonts.titleBold()
        label.textColor = KarhooUI.colors.infoColor
        label.text = UITexts.CountryCodeSelection.title
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.accessibilityIdentifier = KHCountryCodeSelectionViewID.tableView
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.bounces = false
        return tableView
    }()
    
    // MARK: - Init
    init(presenter: CountryCodeSelectionPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.anchor(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.layer.cornerRadius = 10.0
        setupView()
    }
    
    private func setupView() {
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor,
                          leading: view.leadingAnchor,
                          paddingTop: standardSpacing,
                          width: standardButtonSize * 2,
                          height: standardButtonSize * 2)
        
        view.addSubview(pageTitleLabel)
        pageTitleLabel.anchor(top: backButton.bottomAnchor,
                              leading: view.leadingAnchor,
                              trailing: view.trailingAnchor,
                              paddingLeft: standardSpacing,
                              paddingRight: standardSpacing)
        
        view.addSubview(tableView)
        tableView.anchor(top: pageTitleLabel.bottomAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor,
                         paddingTop: standardSpacing)
        tableViewBottomConstraint = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        tableViewBottomConstraint.isActive = true
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = UITexts.CountryCodeSelection.search
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        setUpTable()
    }
    
    private func setUpTable() {
        data = TableData<Country>()
        source = TableDataSource<Country>(reuseIdentifier: tableViewReuseIdentifier, tableData: data)
        delegate = TableDelegate<Country>(tableData: data)
        delegate.setSection(key: delegateKey, to: presenter.filterData(filter: ""))
        
        tableView.register(CountryCodeTableViewCell.self, forCellReuseIdentifier: tableViewReuseIdentifier)
        tableView.dataSource = source
        tableView.delegate = delegate
        
        // Using footerView because content inset can't be used
        let footer = UIView(frame: .init(x: 0, y: 0, width: 50, height: 50 + 20))
        footer.backgroundColor = .clear
        tableView.tableFooterView = footer

        func cellCallback(country: Country, cell: UITableViewCell, indexPath: IndexPath) {
            guard let cell = cell as? CountryCodeTableViewCell else {
                return
            }
            let viewModel = CountryCodeViewModel(country: country, isSelected: presenter.preSelectedCountry?.code == country.code)
            cell.set(viewModel: viewModel)
        }

        source.set(cellConfigurationCallback: cellCallback)
        
        delegate.set(selectionCallback: { [weak self] (country: Country) in
            guard let self = self else {
                return
            }
            self.dismissScreen()
            self.presenter.countrySelected(country: country)
        })
    }
    
    deinit {
        keyboardSizeProvider.remove(listener: self)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardSizeProvider.register(listener: self)
    }
    
    // MARK: - Actions
    @objc private func backButtonPressed() {
        dismissScreen()
        presenter.backClicked()
    }
    
    // MARK: - Search
    private func filterContentForSearchText(_ searchText: String) {
        let filtered = presenter.filterData(filter: searchText)
        delegate.setSection(key: delegateKey, to: filtered)
        tableView.reloadData()
    }
    
    // MARK: - Utils
    func dismissScreen() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CountryCodeSelectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text ?? "")
    }
}

extension CountryCodeSelectionViewController: KeyboardListener {
    func keyboard(updatedHeight: CGFloat) {
        tableViewBottomConstraint.constant = -updatedHeight
        view.layoutIfNeeded()
    }
}
