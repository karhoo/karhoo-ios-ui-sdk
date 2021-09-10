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

    private let standardButtonSize: CGFloat = 44.0
    private let standardSpacing: CGFloat = 20.0
    private let extraSmallSpacing: CGFloat = 4.0
    private var presenter: CountryCodeSelectionPresenter
    private var tableViewBottomConstraint: NSLayoutConstraint!
    private let searchController = UISearchController(searchResultsController: nil)
    private var data = [Country]()
    private var filteredData = [Country]()
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
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.accessibilityIdentifier = KHCountryCodeSelectionViewID.tableView
        tableView.separatorStyle = .none
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
    }
    
    // MARK: - Actions
    @objc private func backButtonPressed() {
        dismissScreen()
        presenter.backClicked()
    }
    
    // MARK: - Search
    private func filterContentForSearchText(_ searchText: String) {
        //filter
        tableView.reloadData()
    }
    
    // MARK: - Utils
    func dismissScreen() {
        self.dismiss(animated: false, completion: nil)
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
