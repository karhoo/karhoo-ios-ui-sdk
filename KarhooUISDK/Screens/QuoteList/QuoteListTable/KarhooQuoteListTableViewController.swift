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

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    private var presenter: QuoteListTablePresenter!

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

    private weak var headerView: UIView?
    
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
        assert(presenter != nil, "Presented needs to be assinged using `setupBinding` method")
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animate: Bool) {
        super.viewWillAppear(animate)
        presenter.viewWillAppear()
    }

    // MARK: - Setup binding

    func setupBinding(_ presenter: QuoteListTablePresenter) {
        self.presenter = presenter
        presenter.onQuoteListStateUpdated = { [weak self] state in
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
        guard viewIsOnScreen else { return }
        tableView.backgroundView = nil
        if tableView.visibleCells.isEmpty == false && tableView.numberOfRows(inSection: 0) == 0 {
            tableView.beginUpdates()
            tableView.deleteSections(IndexSet(integer: 0), with: .automatic)
            tableView.endUpdates()
        } else {
            tableView.reloadData()
        }
    }

    private func handleFetchingState() {
        guard viewIsOnScreen else { return }
        tableView.backgroundView = nil
        if tableView.visibleCells.isEmpty && tableView.numberOfRows(inSection: 0) > 0 {
            tableView.beginUpdates()
            tableView.insertSections(IndexSet(integer: 0), with: .automatic)
            tableView.endUpdates()
        } else {
            tableView.reloadData()
        }
    }

    private func handleFetchedState() {
        tableView.reloadData()
        tableView.backgroundView = nil
    }

    private func handleEmptyState(_ reason: QuoteListState.EmptyReason) {
        tableView.reloadData()
        let emptyView = QuoteListEmptyView(using: presenter.getEmptyReasonViewModel(), delegate: self)
        let currentEmptyView = tableView.backgroundView as? QuoteListEmptyView
        let shouldReplaceEmptyView = currentEmptyView?.viewModel != emptyView.viewModel
        tableView.backgroundView = shouldReplaceEmptyView ? emptyView : tableView.backgroundView
    }
    
    // MARK: - Utils
    
    private func getQuotes() -> [Quote] {
        switch presenter.state {
        case .loading, .empty:
            return []
        case .fetching(let quotes), .fetched(let quotes):
            return quotes
        }
    }

    // MARK: - Scene Input methods

    func assignHeaderView(_ view: UIView) {
        headerView = view
    }
}

    // MARK: - TableView delegate & data source
extension KarhooQuoteListTableViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView else { return nil }
        let view = UIView()
        view.addSubview(headerView)
        headerView.anchorToSuperview(
            paddingTop: UIConstants.Spacing.medium,
            paddingLeading: UIConstants.Spacing.medium,
            paddingTrailing: UIConstants.Spacing.medium,
            paddingBottom: -UIConstants.Spacing.xSmall
        )
        view.layoutIfNeeded()
        return view
    }

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
        presenter.onQuoteSelected(quote)
    }
}

extension KarhooQuoteListTableViewController: QuoteListErrorViewDelegate {
    func showNoCoverageEmail() {
        presenter.showNoCoverageEmail()
    }
}
