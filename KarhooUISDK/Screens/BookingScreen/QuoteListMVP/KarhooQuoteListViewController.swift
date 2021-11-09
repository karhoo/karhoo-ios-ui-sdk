//
//  QuoteListViewController.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

public struct KHQuoteListViewID {
    public static let prebookQuotesTitleLabel = "prebook_label"
    public static let tableViewReuseIdentifier = "QuoteCell"
}

final class KarhooQuoteListViewController: UIViewController, QuoteListView {
    
    private var didSetupConstraints = false
    
    private weak var quoteListActions: QuoteListActions?
    private var loadingView: LoadingView!
    private var stackView: UIStackView!
    private var quoteSortView: KarhooQuoteSortView!
    private var prebookQuotesTitleLabel: UILabel!
    private var emptyDataSetView: QuoteListEmptyDataSetView!
    private var quoteCategoryBarView: KarhooQuoteCategoryBarView!
    
    private(set) var tableView: UITableView!
    private let tableViewReuseIdentifier = KHQuoteListViewID.tableViewReuseIdentifier
    private var data: TableData<Quote>!
    private var source: TableDataSource<Quote>!
    private var delegate: TableDelegate<Quote>! // swiftlint:disable:this weak_delegate
    private var presenter: QuoteListPresenter?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forceLightMode()
    }
    
    override func loadView() {
        setUpView()
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
        
        prebookQuotesTitleLabel = UILabel()
        prebookQuotesTitleLabel.accessibilityIdentifier = KHQuoteListViewID.prebookQuotesTitleLabel
        prebookQuotesTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        prebookQuotesTitleLabel.textAlignment = .center
        prebookQuotesTitleLabel.font = KarhooUI.fonts.bodyRegular()
        prebookQuotesTitleLabel.textColor = KarhooUI.colors.medGrey
        prebookQuotesTitleLabel.isHidden = true
        stackView.addArrangedSubview(prebookQuotesTitleLabel)
        
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
        
        data = TableData<Quote>()
        source = TableDataSource<Quote>(reuseIdentifier: tableViewReuseIdentifier, tableData: data)
        delegate = TableDelegate<Quote>(tableData: data)
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.accessibilityIdentifier = "table_view"
        setUpTable()
        stackView.addArrangedSubview(tableView)
        
        loadingView = LoadingView()
        loadingView.set(backgroundColor: .clear)
        loadingView.set(activityIndicatorColor: KarhooUI.colors.darkGrey)
        view.addSubview(loadingView)
        view.bringSubviewToFront(loadingView)
        
        view.setNeedsUpdateConstraints()
        
        presenter = KarhooQuoteListPresenter(quoteListView: self)
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
            
            _ = [prebookQuotesTitleLabel.heightAnchor.constraint(equalToConstant: 55.0)].map { $0.isActive = true }
            
            let quoteCategoryHeight: CGFloat = 65.0
            _ = [quoteCategoryBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                 quoteCategoryBarView.heightAnchor.constraint(equalToConstant: quoteCategoryHeight),
                 quoteCategoryBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor)]
                .map { $0.isActive = true }
            
            _ = [tableView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
                 tableView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)].map { $0.isActive = true }

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
    
    private func setUpTable() {
        tableView.register(QuoteCell.self, forCellReuseIdentifier: tableViewReuseIdentifier)
        tableView.dataSource = source
        tableView.delegate = delegate
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50.0
        tableView.separatorStyle = .none
        
        // Using footerView because content inset can't be used
        let footer = UIView(frame: .init(x: 0, y: 0, width: 50, height: 50 + 20))
        footer.backgroundColor = .clear
        tableView.tableFooterView = footer

        func cellCallback(quote: Quote, cell: UITableViewCell, indexPath: IndexPath) {
            guard let cell = cell as? QuoteCell else {
                return
            }
            let viewModel = QuoteViewModel(quote: quote)
            cell.set(viewModel: viewModel)
        }

        source.set(cellConfigurationCallback: cellCallback)
        
        delegate.set(selectionCallback: { [weak self] (quote: Quote) in
            guard let self = self else {
                return
            }
            self.quoteListActions?.didSelectQuote(quote)
        })
    }
    
    func set(quoteListActions: QuoteListActions) {
        self.quoteListActions = quoteListActions
    }
    
    func showQuotes(_ quotes: [Quote], animated: Bool) {
        if tableView.alpha == 0 {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.tableView.alpha = 1
            }
        }
        emptyDataSetView.hide()
        
        delegate.setSection(key: "", to: quotes)
        if data.getItems(section: 0).count > 0, animated {
            tableView.reloadSections([0],
                                     with: .fade)
        } else {
            tableView.reloadData()
        }
    }
    
    func showEmptyDataSetMessage(_ message: String) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.tableView.alpha = 0
        }
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
    
    func showQuotesTitle(_ title: String) {
        prebookQuotesTitleLabel.text = title
        prebookQuotesTitleLabel.isHidden = false
    }
    
    func hideQuotesTitle() {
        prebookQuotesTitleLabel.isHidden = true
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
