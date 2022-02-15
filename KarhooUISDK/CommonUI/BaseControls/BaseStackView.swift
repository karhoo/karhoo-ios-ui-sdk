//
//  StackBaseView.swift
//  DetailRatingView
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

class BaseStackView: UIView {

    // MARK: - Properties

    private var viewList = [String]()
    private var keyboardListener: KeyboardSizeProviderProtocol = KeyboardSizeProvider()
    public var isScrollEnabled: Bool {
        get {
            scrollView.isScrollEnabled
        }
        set {
            if newValue != scrollView.isScrollEnabled {
                setNeedsUpdateConstraints()
            }
            scrollView.isScrollEnabled = newValue
        }
    }

    // MARK: Views

    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let scrollViewContentView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let stackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.distribution = .fill
        $0.alignment = .center
        $0.axis = .vertical
        $0.spacing = 0
        $0.isUserInteractionEnabled = true
    }

    // MARK: - Lifecycle
    
    public init() {
        super.init(frame: .zero)
        setUp()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    deinit {
        keyboardListener.remove(listener: self)
    }

    // MARK: - Setup

    private func setUp() {
        keyboardListener.register(listener: self)
        setupProperties()
        setupHierarchy()
        setupLayout()
    }
    
    private func setupProperties() {
        translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupHierarchy() {
        addSubview(scrollView)
        scrollViewContentView.addSubview(stackView)
        scrollView.addSubview(scrollViewContentView)
    }

    private func setupLayout() {
        scrollView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            paddingBottom: safeAreaInsets.bottom
        )
        scrollViewContentView.anchorToSuperview()
        stackView.anchorToSuperview()
    }

    // MARK: - Endpoints

    func addViewToStack(view: UIView) {
        guard let viewIdentifier = view.accessibilityIdentifier else {
            assertionFailure("No accessibility Identifier provided for view: \(view)")
            return
        }
        
        if viewList.contains(viewIdentifier) {
            assertionFailure("A view with identifier: \(viewIdentifier) already present")
        }
        stackView.addArrangedSubview(view)
        viewList.append(viewIdentifier)
    }

    public func stackSubViews() -> [UIView] {
        return stackView.subviews
    }

    public func viewSpacing(_ spacing: CGFloat) {
        stackView.spacing = spacing
        stackView.setNeedsLayout()
    }

    func scrollTo(_ viewToShow: UIView, animated: Bool) {
        scrollView.scrollRectToVisible(viewToShow.frame, animated: true)
    }
}

extension BaseStackView: KeyboardListener {
    func keyboard(updatedHeight: CGFloat) {
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: updatedHeight, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}
