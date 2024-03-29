//
//  KarhooQuoteListViewController.swift
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

    private weak var viewModel: QuoteListViewModel!
    
    private var resultsAccessibilityTitle: String?

    override var preferredStatusBarStyle: UIStatusBarStyle { .getPrimaryStyle }

    // MARK: - Header views

    private lazy var tableHeaderStackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = UIConstants.Spacing.standard
    }

    private var headerViews: [UIView] {
        [
            addressPickerView,
            buttonsStackView,
            legalDisclaimerContainer
        ]
    }
    private lazy var loadingBar = LoadingBar().then {
        $0.state = .indeterminate
    }
    private lazy var addressPickerView = KarhooComponents.shared.addressBar(journeyInfo: nil).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private lazy var buttonsStackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = UIConstants.Spacing.medium
    }
    private lazy var sortButton = BorderedWOBackgroundButton().then {
        $0.setImage(.uisdkImage("kh_uisdk_arrow_down"), for: .normal)
        $0.setTitle(UITexts.Quotes.sortBy, for: .normal)
        $0.backgroundColor = KarhooUI.colors.white
        $0.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
    }
    private lazy var filtersButton = BorderedWOBackgroundButton().then {
        $0.setImage(.uisdkImage("kh_uisdk_filters_icon"), for: .normal)
        $0.setTitle(UITexts.Quotes.filter, for: .normal)
        $0.backgroundColor = KarhooUI.colors.white
        $0.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
    }
    private lazy var legalDisclaimerContainer = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.alpha = 0
        $0.axis = .horizontal
    }
    private lazy var legalDisclaimerLabel = UILabel().then {
        $0.accessibilityIdentifier = KHQuoteListViewID.prebookQuotesTitleLabel
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setContentHuggingPriority(.init(0), for: .horizontal)
        $0.textAlignment = .right
        $0.font = KarhooUI.fonts.captionSemibold()
        $0.textColor = KarhooUI.colors.text
        $0.text = UITexts.Quotes.feesAndTaxesIncluded
    }

    // MARK: - Nested view controllers

    private lazy var tableViewCoordinator: QuoteListTableCoordinator = KarhooQuoteListTableCoordinator(
        onQuoteSelected: { [weak self] quote in
            self?.viewModel?.didSelectQuote(quote)
        },
        onQuoteDetailsSelected: { [weak self] quote in
            self?.viewModel?.didSelectQuoteDetails(quote)
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
        assert(viewModel != nil, "Presented needs to be assigned using `setupBinding` method")
        viewModel?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        viewModel?.viewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Set the accessibility label to a text that makes sense when selecting the back button from the checkout screen
        // Cannot be nil or empty or else it will default to the actual label text
        // It will be set back to the proper text on viewWillAppear
        navigationItem.accessibilityLabel = UITexts.Accessibility.quoteListTitle
        
        viewModel?.viewWillDisappear()
    }

    // MARK: - Setup binding

    func setupBinding(_ presenter: QuoteListViewModel) {
        self.viewModel = presenter
        loadViewIfNeeded()
        presenter.onStateUpdated = { [weak self] state in
            self?.handleStateUpdate(state)
        }
        presenter.onFiltersCountUpdated = { [weak self] filtersCount in
            self?.updateFilterButtonState(using: filtersCount)
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
        view.backgroundColor = KarhooUI.colors.background1
        forceLightMode()
        setHeaderDisabled(hideSortAndFilterButtons: false, animated: false)
    }

    private func setupHierarchy() {
        let tableViewController = tableViewCoordinator.viewController
        view.addSubview(tableViewController.view)
        addChild(tableViewController)
        view.addSubview(loadingBar)
        buttonsStackView.addArrangedSubviews([
            sortButton,
            filtersButton
        ])
        legalDisclaimerContainer.addArrangedSubview(legalDisclaimerLabel)
        tableHeaderStackView.addArrangedSubviews(headerViews)
        tableViewCoordinator.assignHeaderView(tableHeaderStackView)
    }

    private func setupLayout() {
        tableViewCoordinator.viewController.view.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            bottom: view.bottomAnchor
        )
        loadingBar.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            height: UIConstants.Dimension.View.loadingBarHeight
        )
        legalDisclaimerLabel.anchorToSuperview()
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backButtonTitle = ""
        
        // This is set to nil on first appearance, the proper value will be added after the data is fetched
        // Used to put back the proper accessibility label when coming back from the next screen
        navigationItem.accessibilityLabel = resultsAccessibilityTitle
        
        navigationController?.set(style: .primary)
    }
    
    // MARK: - State handling

    private func updateFilterButtonState(using filtersCount: Int) {
        switch filtersCount {
        case 0: filtersButton.isSelected = false
        default: filtersButton.setSelected(withNumber: filtersCount)
        }
        
    }

    private func handleStateUpdate(_ state: QuoteListState) {
        setNavigationBarTitle(forState: state)
        switch state {
        case .loading:
            handleLoadingState()
        case .fetching(quotes: let quotes):
            handleFetchingState(quotes: quotes)
        case .fetched(quotes: let quotes):
            handleFetchedState(quotes: quotes)
        case .empty(reason: let reason):
            handleEmptyState(reason: reason)
        }
    }
    
    private func handleLoadingState() {
        tableViewCoordinator.updateQuoteListState(.loading)
        loadingBar.startAnimation()
        setHeaderDisabled(hideLegalDisclaimer: true)
    }

    private func handleFetchingState(quotes: [Quote]) {
        setHeaderEnabled { [weak self] in
            self?.tableViewCoordinator.updateQuoteListState(.fetching(quotes: quotes))
        }
    }

    private func handleFetchedState(quotes: [Quote]) {
        loadingBar.stopAnimation()
        setHeaderEnabled { [weak self] in
            self?.tableViewCoordinator.updateQuoteListState(.fetched(quotes: quotes))
        }
    }
    
    private func handleEmptyState(reason: QuoteListState.EmptyReason) {
        loadingBar.stopAnimation()
        let hideSortAndFilterButtons: Bool
        switch reason {
        case .noQuotesAfterFiltering:
            hideSortAndFilterButtons = false
        default:
            hideSortAndFilterButtons = true
        }
        setHeaderDisabled(
            hideSortAndFilterButtons: hideSortAndFilterButtons,
            hideLegalDisclaimer: true
        ) { [weak self] in
            self?.tableViewCoordinator.updateQuoteListState(.empty(reason: reason))
        }
    }

    // MARK: - Helpers

    private func setHeaderEnabled(completion: @escaping () -> Void = { }) {
        buttonsStackView.isHidden = false
        sortButton.isHidden = !viewModel.isSortingAvailable
        UIView.animate(
            withDuration: UIConstants.Duration.medium,
            delay: 0,
            options: .curveEaseOut,
            animations: { [weak self] in
                self?.buttonsStackView.alpha = 1
                self?.legalDisclaimerContainer.alpha = 1
            },
            completion: { _ in
                completion()
            }
        )
    }

    private func setHeaderDisabled(
        hideSortAndFilterButtons: Bool = false,
        hideLegalDisclaimer: Bool = false,
        animated: Bool = true,
        completion: @escaping () -> Void = { }
    ) {
        UIView.animate(
            withDuration: animated ? UIConstants.Duration.medium : 0,
            delay: 0,
            options: .curveEaseOut,
            animations: { [weak self] in
                let alpha: CGFloat = hideSortAndFilterButtons ? 0 : 1
                self?.buttonsStackView.alpha = alpha
                if hideLegalDisclaimer {
                    self?.legalDisclaimerContainer.alpha = 0
                }
            },
            completion: { [weak self] _ in
                guard let self = self else { return }
                self.buttonsStackView.isHidden = hideSortAndFilterButtons
                self.sortButton.isHidden = !self.viewModel.isSortingAvailable
                completion()
            }
        )
    }

    private func setNavigationBarTitle(forState state: QuoteListState) {
        switch state {
        case .loading, .fetching:
            navigationItem.title = ""
        case .fetched(let quotes):
            let message = quotes.count > 1 ? UITexts.Quotes.results : UITexts.Quotes.result
            let title = String(format: message, quotes.count.description)
            navigationItem.title = title
            navigationItem.accessibilityLabel = title
            resultsAccessibilityTitle = title
        case .empty:
            navigationItem.title = ""
        }
    }

    // MARK: - UI Actions

    @objc
    private func sortButtonTapped(_ sender: UIButton) {
        viewModel?.didSelectShowSort()
    }

    @objc
    private func filterButtonTapped(_sender: UIButton) {
        viewModel?.didSelectShowFilters()
    }
}
