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
    
    // TODO: when refactoring KarhooQuoteListViewController remove this legacy tableView instance
//    var tableView: UITableView!
    private var didSetupConstraints = false
    
//    private weak var quoteListActions: QuoteListActions?
    private var loadingView: LoadingView!
    private var stackView: UIStackView!
    private var quoteSortView: KarhooQuoteSortView!
    private var legalDisclaimerLabel = UILabel().then {
        $0.accessibilityIdentifier = KHQuoteListViewID.prebookQuotesTitleLabel
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .center
        $0.isHidden = true
        $0.font = KarhooUI.fonts.bodyRegular()
        $0.textColor = KarhooUI.colors.text
        $0.text = UITexts.Quotes.feesAndTaxesIncluded
    }
    private var emptyDataSetView: QuoteListEmptyDataSetView!
    private var quoteCategoryBarView: KarhooQuoteCategoryBarView!
    private var presenter: QuoteListPresenter!

    // MARK: - Nested view controllers

    private lazy var tableViewController = QuoteListTable.build(
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
    
    // MARK: - Setup Navigation Bar
    
    private func setupNavigationBar(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: KarhooUI.colors.white]
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
    // MARK: - Setup binding

    func setupBinding(_ presenter: QuoteListPresenter) {
        self.presenter = presenter
        loadViewIfNeeded()
        presenter.onStateUpdated = { [weak self] state in
            self?.handleStateUpdate(state)
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
        view.addSubview(tableViewController.view)
        addChild(tableViewController)
    }

    private func setupLayout() {
        tableViewController.view.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor
        )
    }
    
    // MARK: - State handling

    private func handleStateUpdate(_ state: QuoteListState) {
        setNavigationBarTitle(forState: state)
        switch state {
        case .loading:
            self.handleLoadingState()
        case .fetched(quotes: let quotes):
            self.handleFetchedState(quotes: quotes)
        case .empty(reason: let reason):
            self.handleEmptyState(reason: reason)
        }
    }
    
    private func handleLoadingState() {
        tableViewController.updateQuoteListState(.loading)
    }
    
    private func handleFetchedState(quotes: [Quote]) {
        tableViewController.updateQuoteListState(.fetched(quotes: quotes))
        legalDisclaimerLabel.isHidden = false
        //TODO: Remove view from layout in future
//        emptyDataSetView.hide()
    }
    
    private func handleEmptyState(reason: QuoteListState.Error) {
        tableViewController.updateQuoteListState(.empty(reason: reason))
    }
    // TODO: Prepare and update values for all possible cases
    private func setNavigationBarTitle(forState state: QuoteListState){
        switch state {
        case .loading:
            navigationItem.title = "LOADING..."
        case .fetched(let quotes):
            navigationItem.title = "\(quotes.count) RESULTS"
        case .empty(_):
            navigationItem.title = "0 RESULTS"
        }
    }

//    private func setUpView() {
//        view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .white
//        view.layer.cornerRadius = 10.0
//        view.layer.masksToBounds = true
//
//        stackView = UIStackView()
//        stackView.accessibilityIdentifier = "stack_view"
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        view.addSubview(stackView)
//
//        quoteSortView = KarhooQuoteSortView()
//        quoteSortView?.set(actions: self)
//        stackView.addArrangedSubview(quoteSortView)
//
//        quoteCategoryBarView = KarhooQuoteCategoryBarView()
//        quoteCategoryBarView?.set(actions: self)
//        quoteCategoryBarView.isHidden = true
//        stackView.addArrangedSubview(quoteCategoryBarView)
//
//        emptyDataSetView = QuoteListEmptyDataSetView()
//        emptyDataSetView.hide()
//        stackView.addArrangedSubview(emptyDataSetView)
//
//        tableView = UITableView()
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//
//        loadingView = LoadingView()
//        loadingView.set(backgroundColor: .clear)
//        loadingView.set(activityIndicatorColor: KarhooUI.colors.darkGrey)
//        view.addSubview(loadingView)
//        view.bringSubviewToFront(loadingView)
//
//        setupLegalDisclaimerLabel()
//        setupNestedTableViewController()
//
//        view.setNeedsUpdateConstraints()
//    }

    private func setupLegalDisclaimerLabel() {
        stackView.insertArrangedSubview(legalDisclaimerLabel, at: 0)
    }
    
//    func set(quoteListActions: QuoteListActions) {
//        self.quoteListActions = quoteListActions
//    }
    
//    func showQuotes(_ quotes: [Quote], animated: Bool) {
//        tableViewController.updateQuoteListState(.fetched(quotes: quotes))
//        legalDisclaimerLabel.isHidden = false
//        emptyDataSetView.hide()
//    }
    
    func showEmptyDataSetMessage(_ message: String) {
    }
    
//    func hideEmptyDataSetMessage() {
//        emptyDataSetView.hide()
//    }
    
//    func didSelectQuoteCategory(_ category: QuoteCategory) {
//        presenter?.selectedQuoteCategory(category)
//    }
    
    func categoriesChanged(categories: [QuoteCategory], quoteListId: String?) {
        quoteCategoryBarView.categoriesChanged(categories: categories, quoteListId: quoteListId)
    }

//    func toggleCategoryFilteringControls(show: Bool) {
//        quoteSortView.alpha = show ? 1 : 0
//        quoteCategoryBarView.isHidden = !show
//    }
    
//    func hideLoadingView() {
//        loadingView.hide()
//    }
//
//    func showLoadingView() {
//        loadingView.show()
//        emptyDataSetView.hide()
//        legalDisclaimerLabel.isHidden = true
//        view.layoutIfNeeded()
//        view.setNeedsLayout()
//    }

//    func quotesAvailabilityDidUpdate(availability: Bool) {
//        quoteListActions?.quotesAvailabilityDidUpdate(availability: availability)
//    }

    func showQuoteSorter() {
        quoteSortView.isHidden = false
    }
    
    func hideQuoteSorter() {
        quoteSortView.isHidden = true
    }
    
    func categoriesDidChange(categories: [QuoteCategory], quoteListId: String?) {
        quoteCategoryBarView.categoriesChanged(categories: categories, quoteListId: quoteListId)
    }
}

extension KarhooQuoteListViewController: QuoteSortViewActions {
    
    func didSelectQuoteOrder(_ order: QuoteSortOrder) {
        presenter?.didSelectQuoteOrder(order)
    }
}

extension KarhooQuoteListViewController: QuoteCategoryBarActions {
    
    func didSelectCategory(_ category: QuoteCategory) {
        presenter?.didSelectCategory(category)
    }
}
