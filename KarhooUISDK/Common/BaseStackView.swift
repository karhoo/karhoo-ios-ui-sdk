//
//  StackBaseView.swift
//  DetailRatingView
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

class BaseStackView: UIView {
    
    private var scrollView: UIScrollView!
    private var stackContainer: UIStackView!
    private var didSetupConstraints: Bool = false
    private var viewList = [String]()
    private var keyboardListener: KeyboardSizeProviderProtocol = KeyboardSizeProvider()
    public var isScrollEnabled: Bool {
        get {
        return scrollView.isScrollEnabled
        }
        set {
        if newValue != scrollView.isScrollEnabled {
            didSetupConstraints = false
            setNeedsUpdateConstraints()
        }
        scrollView.isScrollEnabled = newValue
        }
    }
    
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

    override public func updateConstraints() {
        if !didSetupConstraints {
            
            var bottomInset: CGFloat = 0.0
            
            if #available(iOS 11.0, *) {
                bottomInset = safeAreaInsets.bottom
            }
            
            _ = [scrollView.topAnchor.constraint(equalTo: self.topAnchor),
                 scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                 scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                 scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                    constant: -bottomInset)].map { $0.isActive = true }
            
            _ = [stackContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
                 stackContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
                 stackContainer.bottomAnchor.constraint(greaterThanOrEqualTo: scrollView.bottomAnchor)]
                .map { $0.isActive = true }
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    // ===================================================
    // MARK: Private func
    private func setUp() {
        keyboardListener.register(listener: self)
        translatesAutoresizingMaskIntoConstraints = false
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        stackContainer = buildStackView()
        scrollView.addSubview(stackContainer)
    }
    
    private func buildStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 0.0
        stackView.isUserInteractionEnabled = true
        return stackView
    }
    
    // ===================================================
    // MARK: Public func
   func addViewToStack(view: UIView) {
        guard let viewIdentifier = view.accessibilityIdentifier else {
            fatalError("No accessibility Identifier provided for view: \(view)")
        }
        
        if viewList.contains(viewIdentifier) {
            fatalError("A view with identifier: \(viewIdentifier) already present")
        }
        stackContainer.addArrangedSubview(view)
        viewList.append(viewIdentifier)
    }
    
    public func stackSubViews() -> [UIView] {
        return stackContainer.subviews
    }
    
    public func viewSpacing(_ spacing: CGFloat) {
        stackContainer.spacing = spacing
        stackContainer.setNeedsLayout()
    }
}

extension BaseStackView: KeyboardListener {
    func keyboard(updatedHeight: CGFloat) {
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: updatedHeight, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}
