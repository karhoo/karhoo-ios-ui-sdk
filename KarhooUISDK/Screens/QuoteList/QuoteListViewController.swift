//
//  QuoteListViewController.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK
import UIKit

public struct KHQuoteListViewID {
    public static let prebookQuotesTitleLabel = "taxes_and_fees_included_label"
    public static let tableViewReuseIdentifier = "QuoteCell"
}

final class KarhooQuoteListViewController: UIViewController, BaseViewController, QuoteListViewController {

    // MARK: - Properties

    private weak var presenter: QuoteListPresenter?

    // MARK: - Header views

    private lazy var headerContainerView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private lazy var tableHeaderStackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = UIConstants.Spacing.standard
    }
    private var headerViews: [UIView] {
        [
            addressPickerView,
            quoteCategoryBarView,
            quoteSortView,
            legalDisclaimerLabel
        ]
    }
    private lazy var addressPickerView = KarhooComponents.shared.addressBar(journeyInfo: nil).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private lazy var quoteSortView = KarhooQuoteSortView().then {
        $0.set(actions: self)
    }
    private lazy var quoteCategoryBarView = KarhooQuoteCategoryBarView().then {
        $0.set(actions: self)
    }
    private lazy var legalDisclaimerLabel = UILabel().then {
        $0.accessibilityIdentifier = KHQuoteListViewID.prebookQuotesTitleLabel
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        $0.textAlignment = .center
        $0.font = KarhooUI.fonts.bodyRegular()
        $0.textColor = KarhooUI.colors.text
        $0.text = UITexts.Quotes.feesAndTaxesIncluded
    }

    // MARK: - Nested view controllers

    private lazy var tableViewCoordinator: QuoteListTableCoordinator = KarhooQuoteListTableCoordinator(
        onQuoteSelected: { [weak self] quote in
            self?.presenter?.didSelectQuote(quote)
        },
        onQuoteDetailsSelected: { [weak self] quote in
            self?.presenter?.didSelectQuoteDetails(quote)
        }
    )

    // MARK: - Lifecycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        setupView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(presenter != nil, "Presented needs to be assinged using `setupBinding` method")
        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        presenter?.viewWillAppear()
    }

    // MARK: - Setup binding

    func setupBinding(_ presenter: QuoteListPresenter) {
        self.presenter = presenter
        loadViewIfNeeded()
        presenter.onStateUpdated = { [weak self] state in
            self?.handleStateUpdate(state)
        }
        presenter.onCategoriesUpdated = { [weak self] categories in
            self?.handleCategoriesUpdated(categories)
        }
    }

    // MARK: - Setup view

    private func setupView() {
        setupProperties()
        setupHierarchy()
        setupLayout()
    }

    private func setupProperties() {
        view = UIView()
        forceLightMode()
    }

    private func setupHierarchy() {
        let tableViewController = tableViewCoordinator.viewController
        view.addSubview(tableViewController.view)
        addChild(tableViewController)
        headerViews.forEach { tableHeaderStackView.addArrangedSubview($0) }
        headerContainerView.addSubview(tableHeaderStackView)
        tableViewCoordinator.assignHeaderView(headerContainerView)
    }

    private func setupLayout() {
        tableViewCoordinator.viewController.view.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor
        )

        quoteCategoryBarView.heightAnchor.constraint(
            equalToConstant: UIConstants.Dimension.View.largeRowHeight
        ).isActive = true

        tableHeaderStackView.anchorToSuperview(
            paddingTop: UIConstants.Spacing.medium,
            paddingLeading: UIConstants.Spacing.medium,
            paddingTrailing: UIConstants.Spacing.medium,
            paddingBottom: UIConstants.Spacing.small
        )
        
        headerContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: KarhooUI.colors.white
        ]
        // back button for iOS < 13 must be configured in "previous" view controller,
        if #available(iOS 13.0, *) {
            let backArrow = UIImage.uisdkImage("back_arrow")
            let navigationBarColor = KarhooUI.colors.primary
            navigationController?.navigationBar.backItem?.title = ""
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = navigationBarColor
            appearance.setBackIndicatorImage(backArrow, transitionMaskImage: backArrow)
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        }
    }
    
    // MARK: - State handling

    private func handleStateUpdate(_ state: QuoteListState) {
        setNavigationBarTitle(forState: state)
        switch state {
        case .loading:
            self.handleLoadingState()
        case .fetching(quotes: let quotes):
            self.handleFetchingState(quotes: quotes)
        case .fetched(quotes: let quotes):
            self.handleFetchedState(quotes: quotes)
        case .empty(reason: let reason):
            self.handleEmptyState(reason: reason)
        }
    }
    
    private func handleLoadingState() {
        tableViewCoordinator.updateQuoteListState(.loading)
        setHeaderDisabled()
    }

    private func handleFetchingState(quotes: [Quote]) {
        tableViewCoordinator.updateQuoteListState(.fetching(quotes: quotes))
        setHeaderEnabled()
    }

    private func handleFetchedState(quotes: [Quote]) {
        tableViewCoordinator.updateQuoteListState(.fetched(quotes: quotes))
        setHeaderEnabled()
    }
    
    private func handleEmptyState(reason: QuoteListState.Error) {
        tableViewCoordinator.updateQuoteListState(.empty(reason: reason))
        setHeaderDisabled()
    }

    private func setHeaderEnabled() {
        UIView.animate(withDuration: UIConstants.Duration.short) { [weak self] in
            self?.quoteCategoryBarView.setEnabled()
            self?.quoteSortView.setEnabled()
            self?.legalDisclaimerLabel.isHidden = false
        }
    }

    private func setHeaderDisabled() {
        UIView.animate(withDuration: UIConstants.Duration.short) { [weak self] in
            self?.quoteCategoryBarView.setDisabled()
            self?.quoteSortView.setDisabled()
            self?.legalDisclaimerLabel.isHidden = true
        }
    }

    // TODO: Prepare and update values for all possible cases
    private func setNavigationBarTitle(forState state: QuoteListState){
        switch state {
        case .loading, .fetching:
            navigationItem.title = "LOADING..."
        case .fetched(let quotes):
            navigationItem.title = "\(quotes.count) RESULTS"
        case .empty:
            navigationItem.title = "0 RESULTS"
        }
    }

    // MARK: - Categories handling

    private func handleCategoriesUpdated(_ categories: [QuoteCategory]) {
        quoteCategoryBarView.set(categories: categories)
    }
}

// MARK: - QuoteSortViewActions
extension KarhooQuoteListViewController: QuoteSortViewActions {
    
    func didSelectQuoteOrder(_ order: QuoteSortOrder) {
        presenter?.didSelectQuoteOrder(order)
    }
}

// MARK: - QuoteCategoryBarActions
extension KarhooQuoteListViewController: QuoteCategoryBarActions {
    
    func didSelectCategory(_ category: QuoteCategory) {
        presenter?.didSelectCategory(category)
    }
}
