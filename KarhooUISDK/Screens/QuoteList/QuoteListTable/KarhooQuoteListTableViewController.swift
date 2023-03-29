//  
//  QuoteListTableViewController.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import UIKit
import KarhooSDK

class KarhooQuoteListTableViewController: UIViewController, BaseViewController, QuoteListTableViewController {

    // MARK: - Properties

    override var preferredStatusBarStyle: UIStatusBarStyle { .getPrimaryStyle }
    private var viewModel: QuoteListTableViewModel!

    // MARK: - Views

    private lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        $0.dataSource = self
        $0.bounces = false
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.accessibilityIdentifier = "table_view"
        $0.register(QuoteCell.self, forCellReuseIdentifier: String(describing: QuoteCell.self))
    }
    
    // MARK: - Lifecycle

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func loadView() {
        view = UIView()
        setupView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(viewModel != nil, "viewModel needs to be assinged using `setupBinding` method")
        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animate: Bool) {
        super.viewWillAppear(animate)
        viewModel.viewWillAppear()
    }

    // MARK: - Setup binding

    func setupBinding(_ viewModel: QuoteListTableViewModel) {
        self.viewModel = viewModel
        viewModel.onQuoteListStateUpdated = { [weak self] state in
            self?.handleState(state)
        }
    }

    // MARK: - Setup view

    private func setupView() {
        setupProperties()
        setupHierarchy()
        setupLayout()
    }

    private func setupProperties() {
        view.backgroundColor = .clear
    }

    private func setupHierarchy() {
        view.addSubview(tableView)
    }

    private func setupLayout() {
        tableView.anchorToSuperview()
    }

    // MARK: - State handling

    private func handleState(_ state: QuoteListState) {
        switch state {
        case .loading:
            handleLoadingState()
        case .fetching:
            handleFetchingState()
        case .fetched:
            handleFetchedState()
        case .empty(let reason):
            handleEmptyState(reason)
        }
    }

    private func handleLoadingState() {
        tableView.backgroundView = nil
        guard viewIsOnScreen else { return }
        tableView.reloadData()
    }

    private func handleFetchingState() {
        guard viewIsOnScreen else { return }
        tableView.backgroundView = nil
        tableView.reloadData()
    }

    private func handleFetchedState() {
        tableView.reloadData()
        tableView.backgroundView = nil
    }

    private func handleEmptyState(_ reason: QuoteListState.EmptyReason) {
        tableView.reloadData()
        let emptyView = QuoteListEmptyView(using: viewModel.getEmptyReasonViewModel(), delegate: self)
        let currentEmptyView = tableView.backgroundView as? QuoteListEmptyView
        let shouldReplaceEmptyView = currentEmptyView?.viewModel != emptyView.viewModel
        tableView.backgroundView = shouldReplaceEmptyView ? emptyView : tableView.backgroundView
    }
    
    // MARK: - Utils
    
    private func getQuotes() -> [Quote] {
        switch viewModel.state {
        case .loading, .empty:
            return []
        case .fetching(let quotes), .fetched(let quotes):
            return quotes
        }
    }

    // MARK: - Scene Input methods

    func assignHeaderView(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        view.anchorToSuperview(
            paddingTop: UIConstants.Spacing.medium,
            paddingLeading: UIConstants.Spacing.medium,
            paddingTrailing: UIConstants.Spacing.medium
        )
        tableView.tableHeaderView = container
        container.widthAnchor.constraint(equalTo: tableView.widthAnchor).isActive = true
    }
}

    // MARK: - TableView delegate & data source
extension KarhooQuoteListTableViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getQuotes().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: QuoteCell.self), for: indexPath)
        
        if let cell = cell as? QuoteCell, let quote = getQuotes()[safe: indexPath.row] {
            cell.set(viewModel: QuoteViewModel(quote: quote))
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let quote = getQuotes()[safe: indexPath.row] else {
            return
        }
        viewModel.onQuoteSelected(quote)
    }
}

extension KarhooQuoteListTableViewController: QuoteListErrorViewDelegate {
    func showNoCoverageEmail() {
        viewModel.showNoCoverageEmail()
    }
}
