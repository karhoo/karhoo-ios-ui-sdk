//  
//  QuoteListSortViewController.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/03/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import UIKit
import KarhooSDK

class KarhooQuoteListSortViewController: UIViewController, BaseViewController, QuoteListSortViewController {

    // MARK: - Properties

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    private var presenter: QuoteListSortPresenter!

    // MARK: - Views

    private lazy var transparentView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private lazy var visibleContainer = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = KarhooUI.colors.background1
        $0.applyRoundCorners(
            [.layerMinXMinYCorner, .layerMaxXMinYCorner],
            radius: UIConstants.CornerRadius.large
        )
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
        $0.text = UITexts.Generic.sortBy
        $0.textColor = KarhooUI.colors.text
        $0.font = KarhooUI.fonts.subtitleSemibold()
    }
    private lazy var closeButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintColor = KarhooUI.colors.text
        $0.setImage(.uisdkImage("cross_new"), for: .normal)
        $0.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
    }
    private lazy var selectionView = SingleSelectionListView<QuoteListSortOrder>(
        options: presenter.sortOptions,
        selectedOption: presenter.selectedSortOption
    )

    private lazy var confirmButton = MainActionButton().then {
        $0.setTitle(UITexts.Generic.save.uppercased(), for: .normal)
        $0.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
    }
    
    // MARK: - Lifecycle

    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .pageSheet
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

    func setupBinding(_ presenter: QuoteListSortPresenter) {
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
        view.translatesAutoresizingMaskIntoConstraints = false

        // Setup dismiss gestures
        transparentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapped)))
        transparentView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(backgroundPanned)))
        visibleContainer.addGestureRecognizer(
            UIPanGestureRecognizer(
                target: self,
                action: #selector(visibleContainerPanned)
            ).then {
                $0.requiresExclusiveTouchType = true
            }
        )
    }

    private func setupHierarchy() {
        view.addSubview(transparentView)
        view.addSubview(visibleContainer)
        visibleContainer.addSubview(stackView)
        stackView.addArrangedSubviews([
            headerStackView,
            SeparatorView(fixedHeight: UIConstants.Spacing.standard),
            selectionView,
            SeparatorView(fixedHeight: UIConstants.Spacing.standard),
            confirmButton
        ])
        headerStackView.addArrangedSubviews([
            headerLabel,
            closeButton
        ])
    }

    private func setupLayout() {
        transparentView.anchor(
            top: view.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            bottom: visibleContainer.topAnchor
        )
        visibleContainer.anchor(
            left: view.leftAnchor,
            right: view.rightAnchor,
            bottom: view.bottomAnchor
        )
        stackView.anchor(
            top: visibleContainer.topAnchor,
            left: visibleContainer.leftAnchor,
            right: visibleContainer.rightAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            paddingTop: UIConstants.Spacing.standard,
            paddingLeft: UIConstants.Spacing.standard,
            paddingRight: UIConstants.Spacing.standard,
            paddingBottom: UIConstants.Spacing.standard
        )
        headerStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true

        closeButton.anchor(
            width: UIConstants.Dimension.Button.small,
            height: UIConstants.Dimension.Button.small
        )
    }

    // MARK: - Helpers

    // MARK: - UI Actions

    @objc
    private func backgroundTapped(_ sender: UITapGestureRecognizer) {
        presenter.close(save: false)
    }

    @objc
    private func backgroundPanned(_ sender: UIPanGestureRecognizer) {
        // The drag/swipe direction is to the bottom of the screen
        let velocity = sender.velocity(in: view)
        let velocityNoiceCap: CGFloat = 5
        guard velocity.y > velocityNoiceCap else { return }
        presenter.close(save: false)
    }

    @objc
    private func visibleContainerPanned(_ sender: UIPanGestureRecognizer) {
        // Nothing to do here, the interaction should be ignored.
        // Reason for this gesture to exist is to override default UIKit drag-to-dismiss gesture from visible container view.
    }

    @objc
    private func savePressed(_ sender: MainActionButton) {
        presenter.set(sortOption: selectionView.selectedOption ?? .price)
        presenter.close(save: true)
    }

    @objc
    private func closePressed(_ sender: UIButton) {
        presenter.close(save: false)
    }
}
