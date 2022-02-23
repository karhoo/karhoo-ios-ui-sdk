//  
//  NewQuoteListViewController.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import UIKit
import KarhooSDK

class KarhooNewQuoteListViewController: UIViewController, BaseViewController, NewQuoteListViewController {

    // MARK: - Properties

    private var presenter: NewQuoteListPresenter!

    // MARK: - Views

    private lazy var tableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        $0.dataSource = self
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
        assert(presenter != nil, "Presented needs to be assinged using `setupBinding` method")
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animate: Bool) {
        super.viewWillAppear(animate)
        presenter.viewWillAppear()
    }

    // MARK: - Setup business logic

    func setupBinding(_ presenter: NewQuoteListPresenter) {
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
    }

    private func setupHierarchy() {
        view.addSubview(tableView)
    }

    private func setupLayout() {
        tableView.anchorToSuperview()
    }

    // MARK: - State handling

    private func handleState(_ state: QuoteListStete) {
        tableView.beginUpdates()
        
        switch state {
        case .loading:
            handleLoadingState()
        case .fetched:
            handleFetchState()
        case .empty:
            handleEmptyState()
        }
        
        tableView.endUpdates()
    }

    private func handleLoadingState() {
    }

    private func handleFetchState() {
        // hide loader
    }

    private func handleEmptyState() {
    }
    
    // MARK: - Utils
    
    private func getQuotes() -> [Quote] {
        switch presenter.state {
        case .loading, .empty:
            return []
        case .fetched(let quotes):
            return quotes
        }
    }

    // MARK: - Scene Input methods

    func updateQuoteListState(_ state: QuoteListStete) {
        DispatchQueue.main.async { [weak self] in
            self?.presenter.updateQuoteListState(state)
        }
    }
}

    // MARK: - TableView delegate & data source
extension KarhooNewQuoteListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getQuotes().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell().then {
            $0.backgroundColor = .red
        }
    }
}
