//  
//  QuoteListFiltersViewController.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 28/04/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import UIKit
import KarhooSDK

class KarhooQuoteListFiltersViewController: UIViewController, BaseViewController, QuoteListFiltersViewController {

    // MARK: - Properties

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    private var presenter: QuoteListFiltersPresenter!

    // MARK: - Views

    private lazy var scrollView = UIScrollView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private lazy var stackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
    }
    private lazy var headerStackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.distribution = .fill
        $0.alignment = .fill
    }
    private lazy var headerLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = UITexts.Quotes.filter
        $0.textColor = KarhooUI.colors.text
        $0.font = KarhooUI.fonts.subtitleSemibold()
    }
    private lazy var closeButton = UIButton().then {
        $0.tintColor = KarhooUI.colors.text
        $0.setImage(.uisdkImage("cross_new"), for: .normal)
        $0.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
    }
    private lazy var resetButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle(UITexts.Quotes.resetFilter, for: .normal)
        $0.setTitleColor(KarhooUI.colors.accent, for: .normal)
        $0.titleLabel?.font = KarhooUI.fonts.bodySemibold()
        $0.addTarget(self, action: #selector(resetPressed), for: .touchUpInside)
    }
    private lazy var footerView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = KarhooUI.colors.background1
        $0.addShadow()
    }
    private lazy var confirmButton = MainActionButton().then {
        $0.setTitle(UITexts.Generic.save.uppercased(), for: .normal)
        $0.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
    }

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
        updateConfirmButtonTitle()
    }

    // MARK: - Setup business logic

    func setupBinding(_ presenter: QuoteListFiltersPresenter) {
        self.presenter = presenter
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
    }

    private func setupHierarchy() {
        view.addSubview(headerStackView)
        view.addSubview(resetButton)
        view.addSubview(scrollView)
        view.addSubview(footerView)
        scrollView.addSubview(stackView)
        headerStackView.addArrangedSubviews([
            headerLabel,
            closeButton
        ])
        stackView.addArrangedSubviews(FilterViewBuilder.buildFilterViews())
        footerView.addSubview(confirmButton)
    }

    private func setupLayout() {
        scrollView.anchor(
            top: resetButton.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            bottom: footerView.topAnchor,
            paddingTop: UIConstants.Spacing.standard
        )
        stackView.anchor(
            top: scrollView.topAnchor,
            left: scrollView.leftAnchor,
            right: scrollView.rightAnchor, bottom: scrollView.bottomAnchor,
            paddingTop: UIConstants.Spacing.standard,
            paddingLeft: UIConstants.Spacing.standard,
            paddingRight: UIConstants.Spacing.standard,
            paddingBottom: UIConstants.Spacing.standard
        )
        headerStackView.anchor(
            top: view.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: UIConstants.Spacing.standard,
            paddingLeft: UIConstants.Spacing.standard,
            paddingRight: UIConstants.Spacing.standard
        )
        headerStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        resetButton.anchor(
            top: headerStackView.bottomAnchor,
            right: headerStackView.rightAnchor,
            paddingTop: UIConstants.Spacing.large,
            height: UIConstants.Dimension.Button.small
        )
        footerView.anchor(
            top: confirmButton.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            bottom: view.bottomAnchor,
            paddingTop: -UIConstants.Spacing.large
        )
        closeButton.anchor(
            width: UIConstants.Dimension.Button.small,
            height: UIConstants.Dimension.Button.small
        )
        confirmButton.anchor(
            left: footerView.leftAnchor,
            right: footerView.rightAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            paddingLeft: UIConstants.Spacing.standard,
            paddingRight: UIConstants.Spacing.standard,
            paddingBottom: UIConstants.Spacing.large
        )
    }

    // MARK: - Private
    
    private func updateConfirmButtonTitle() {
        let count = presenter.resultsCountForSelectedFilters().description
        let text = String(format: UITexts.Quotes.filterPageResults, count)
        confirmButton.setTitle(text, for: .normal)
    }

    private func filterSelected(_ filter: QuoteListFilter) {
        presenter.filterSelected(filter)
        updateConfirmButtonTitle()
    }

    // MARK: - UI Actions

    @objc
    private func savePressed(_ sender: MainActionButton) {
        presenter.close(save: true)
    }

    @objc
    private func closePressed(_ sender: UIButton) {
        presenter.close(save: false)
    }

    @objc
    private func resetPressed(_ sender: UIButton) {
        presenter.resetFilter()
        // TODO: reset subviews
    }
}
