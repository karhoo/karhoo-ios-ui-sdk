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

final class KarhooQuoteListViewController: UIViewController, QuoteListView {
    // TODO: when refactoring KarhooQuoteListViewController remove this legacy tableView instance
    var tableView: UITableView!
    private var didSetupConstraints = false
    
    private weak var quoteListActions: QuoteListActions?
    private var loadingView: LoadingView!
    private var stackView: UIStackView!
    private var quoteSortView: KarhooQuoteSortView!
    private var legalDisclaimerLabel: UILabel!
    private var emptyDataSetView: QuoteListEmptyDataSetView!
    private var quoteCategoryBarView: KarhooQuoteCategoryBarView!
    private var presenter: QuoteListPresenter?

    // MARK: - Nested view controllers

    private lazy var tableViewController = NewQuoteList.build(
        onQuoteSelected: { [weak self] quote in
            self?.quoteListActions?.didSelectQuote(quote)
        },
        onQuoteDetailsSelected: { _ in
            // TODO: Finish implementation
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
        setUpView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(presenter != nil, "Presented needs to be assinged using `setupBinding` method")
        forceLightMode()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.screenWillAppear()
    }

    func setupBinding(_ presenter: QuoteListPresenter) {
        self.presenter = presenter
        presenter.onStateUpdated = { _ in
            assertionFailure()
            // TODO: tbd
        }
    }

    private func setUpView() {
        view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10.0
        view.layer.masksToBounds = true
        
        stackView = UIStackView()
        stackView.accessibilityIdentifier = "stack_view"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        view.addSubview(stackView)

        quoteSortView = KarhooQuoteSortView()
        quoteSortView?.set(actions: self)
        stackView.addArrangedSubview(quoteSortView)
        
        quoteCategoryBarView = KarhooQuoteCategoryBarView()
        quoteCategoryBarView?.set(actions: self)
        quoteCategoryBarView.isHidden = true
        stackView.addArrangedSubview(quoteCategoryBarView)
        
        emptyDataSetView = QuoteListEmptyDataSetView()
        emptyDataSetView.hide()
        stackView.addArrangedSubview(emptyDataSetView)

        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false

        loadingView = LoadingView()
        loadingView.set(backgroundColor: .clear)
        loadingView.set(activityIndicatorColor: KarhooUI.colors.darkGrey)
        view.addSubview(loadingView)
        view.bringSubviewToFront(loadingView)

        setupLegalDisclaimerLabel()
        setupNestedTableViewController()

        view.setNeedsUpdateConstraints()
        presenter = KarhooQuoteListPresenter(quoteListView: self)
    }

    private func setupNestedTableViewController() {
        tableViewController.loadViewIfNeeded()
        addChild(tableViewController)
        stackView.addArrangedSubview(tableViewController.view)
    }

    private func setupLegalDisclaimerLabel() {
        legalDisclaimerLabel = UILabel()
        legalDisclaimerLabel.accessibilityIdentifier = KHQuoteListViewID.prebookQuotesTitleLabel
        legalDisclaimerLabel.translatesAutoresizingMaskIntoConstraints = false
        legalDisclaimerLabel.textAlignment = .center
        legalDisclaimerLabel.isHidden = true
        legalDisclaimerLabel.font = KarhooUI.fonts.bodyRegular()
        legalDisclaimerLabel.textColor = KarhooUI.colors.medGrey
        stackView.insertArrangedSubview(legalDisclaimerLabel, at: 0)
        legalDisclaimerLabel.text = UITexts.Quotes.feesAndTaxesIncluded
    }
    
    override func updateViewConstraints() {
        if !didSetupConstraints {

            let stackConstraints: [NSLayoutConstraint] = [stackView.topAnchor.constraint(equalTo: view.topAnchor,
                                                                                         constant: 16.0),
                 stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                 stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                 stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
            _ = stackConstraints.map { $0.priority = .defaultLow }
            _ = stackConstraints.map { $0.isActive = true }
            
            legalDisclaimerLabel.heightAnchor.constraint(equalToConstant: UIConstants.Dimension.View.smallRowHeight).isActive = true
            
            let quoteCategoryHeight: CGFloat = 65.0
            _ = [quoteCategoryBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                 quoteCategoryBarView.heightAnchor.constraint(equalToConstant: quoteCategoryHeight),
                 quoteCategoryBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor)]
                .map { $0.isActive = true }

            let loadingConstraints: [NSLayoutConstraint] = [loadingView.topAnchor.constraint(equalTo: view.topAnchor,
                                                                                             constant: 15.0),
                 loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                 loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                 loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                 loadingView.heightAnchor.constraint(equalToConstant: 200.0)]
            _ = loadingConstraints.map { $0.priority = .defaultLow }
            _ = loadingConstraints.map { $0.isActive = true }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }

    // MARK: - Update state

    func updateState(_ state: QuoteListState) {
        // TODO: update state
    }
    
    func set(quoteListActions: QuoteListActions) {
        self.quoteListActions = quoteListActions
    }
    
    func showQuotes(_ quotes: [Quote], animated: Bool) {
        tableViewController.updateQuoteListState(.fetched(quotes: quotes))
        legalDisclaimerLabel.isHidden = false
        emptyDataSetView.hide()
    }
    
    func showEmptyDataSetMessage(_ message: String) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.tableView.alpha = 0
        }
        legalDisclaimerLabel.isHidden = true
        emptyDataSetView.show(emptyDataSetMessage: message)
    }
    
    func hideEmptyDataSetMessage() {
        emptyDataSetView.hide()
    }
    
    func didSelectQuoteCategory(_ category: QuoteCategory) {
        presenter?.selectedQuoteCategory(category)
    }
    
    func categoriesChanged(categories: [QuoteCategory], quoteListId: String?) {
        quoteCategoryBarView.categoriesChanged(categories: categories, quoteListId: quoteListId)
    }

    func toggleCategoryFilteringControls(show: Bool) {
        quoteSortView.alpha = show ? 1 : 0
        quoteCategoryBarView.isHidden = !show
    }
    
    func hideLoadingView() {
        loadingView.hide()
    }
    
    func showLoadingView() {
        loadingView.show()
        emptyDataSetView.hide()
        legalDisclaimerLabel.isHidden = true
        view.layoutIfNeeded()
        view.setNeedsLayout()
    }

    func quotesAvailabilityDidUpdate(availability: Bool) {
        quoteListActions?.quotesAvailabilityDidUpdate(availability: availability)
    }

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
        didSelectQuoteCategory(category)
    }
}
