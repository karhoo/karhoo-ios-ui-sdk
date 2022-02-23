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
    
    // MARK: - Lifecycle

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func loadView() {
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
            switch state {
            case .loading:
                break
            case .fetched(let quotes)
                break
            case empty:
                break
            }
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
    }

    private func setupLayout() {
    }
}
