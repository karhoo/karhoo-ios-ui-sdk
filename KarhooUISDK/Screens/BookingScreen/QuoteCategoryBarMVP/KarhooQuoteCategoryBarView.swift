//
//  KarhooQuoteCategoryBarView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

public struct KHQuoteCategoryBarViewID {
    public static let view = "quote_category_view"
    public static let topLine = "quote_category_top_line_view"
    public static let scrollView = "quote_category_scroll_view"
    public static let stackView = "quote_category_stack_view"
    public static let markerView = "quote_category_marker_view"
    public static let bottomLine = "quote_category_bottom_line_view"
}

final class KarhooQuoteCategoryBarView: UIView, QuoteCategoryBarView {
    
    private var topLine: LineView!
    private var bottomLine: LineView!
    private var markerView: UIView!
    private var markerCenterX: NSLayoutConstraint!
    private var markerWidth: NSLayoutConstraint!
    private var scrollView: UIScrollView!
    private var stackView: UIStackView!
    private var didSetupConstraints: Bool = false
    
    private var presenter: QuoteCategoryBarPresenter?
    private weak var actions: QuoteCategoryBarActions?
    private var categories: [QuoteCategory] = []
    private var labels: [RoundedLabel] = []

    private lazy var hapticGenerator: UIImpactFeedbackGenerator = {
        let generator = UIImpactFeedbackGenerator(style: .light)
        return generator
    }()

    init() {
        super.init(frame: .zero)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        _ = labels.map { $0.cornerRadious = true }
    }
    
    private func setUpView() {
        presenter = KarhooQuoteCategoryBarPresenter(view: self)
        
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHQuoteCategoryBarViewID.view
        backgroundColor = KarhooUI.colors.white
        
        topLine = LineView(color: KarhooUI.colors.lightGrey,
                           accessibilityIdentifier: KHQuoteCategoryBarViewID.topLine)
        addSubview(topLine)
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.accessibilityIdentifier = KHQuoteCategoryBarViewID.scrollView
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        addSubview(scrollView)
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(labelTapped))
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.accessibilityIdentifier = KHQuoteCategoryBarViewID.stackView
        stackView.addGestureRecognizer(tapGesture)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 20.0
        scrollView.addSubview(stackView)
        
        markerView = UIView()
        markerView.translatesAutoresizingMaskIntoConstraints = false
        markerView.accessibilityIdentifier = KHQuoteCategoryBarViewID.markerView
        markerView.backgroundColor = KarhooUI.colors.secondary
        markerView.layer.cornerRadius = 10.0
        stackView.insertSubview(markerView, at: 0)
        
        bottomLine = LineView(color: KarhooUI.colors.lightGrey,
                              accessibilityIdentifier: KHQuoteCategoryBarViewID.bottomLine)
        addSubview(bottomLine)
        
        updateConstraints()
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            _ = [topLine.topAnchor.constraint(equalTo: topAnchor),
                 topLine.leadingAnchor.constraint(equalTo: leadingAnchor),
                 topLine.trailingAnchor.constraint(equalTo: trailingAnchor),
                 topLine.heightAnchor.constraint(equalToConstant: 0.5)].map { $0.isActive = true }
            
            _ = [scrollView.topAnchor.constraint(equalTo: topLine.bottomAnchor),
                 scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
                 scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
                 scrollView.bottomAnchor.constraint(equalTo: bottomLine.topAnchor)].map { $0.isActive = true }
            
            _ = [markerView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
                 markerView.heightAnchor.constraint(equalToConstant: 21.0)].map { $0.isActive = true }
            markerCenterX = markerView.centerXAnchor.constraint(equalTo: stackView.leadingAnchor)
            markerWidth = markerView.widthAnchor.constraint(equalToConstant: 0.0)
            markerCenterX.isActive = true
            markerWidth.isActive = true
            
            _ = [stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20.0),
                 stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20.0),
                 stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20.0),
                 stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor,
                                                   constant: -20.0)].map { $0.isActive = true }
            
            _ = [bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor),
                 bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor),
                 bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor),
                 bottomLine.heightAnchor.constraint(equalToConstant: 0.5)].map { $0.isActive = true }
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
    func set(categories: [QuoteCategory]) {
        self.categories = categories
        
        removeExistingLabels()
        addLabels(for: categories)
        layoutIfNeeded()
        
        if stackView.bounds.width > scrollView.bounds.width {
            let offset = scrollView.contentSize.width - scrollView.frame.width
            scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: false)
            stackView.distribution = offset > 0 ? .fill : .fillProportionally
        }
    }
    
    func set(selectedIndex: Int, animated: Bool) {
        let selectedLabel = labels[selectedIndex]
        markerCenterX.constant = selectedLabel.center.x
        markerWidth.constant = selectedLabel.frame.width + 8
        _ = labels.map { $0.backgroundColor = KarhooUI.colors.lightGrey }
        _ = labels.map { $0.textColor = KarhooUI.colors.darkGrey }
        selectedLabel.backgroundColor = .clear
        
        if animated {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.updateCategories(selectedIndex: selectedIndex)
                self?.layoutIfNeeded()
            }
        } else {
            updateCategories(selectedIndex: selectedIndex)
            layoutIfNeeded()
        }
    }
    
    private func updateCategories(selectedIndex: Int) {
        labels.enumerated().forEach { (index, label) in
            let category = categories[index]
            if index != selectedIndex {
                label.textColor = category.quotes.count == 0 ? KarhooUI.colors.white : KarhooUI.colors.darkGrey
            } else {
                label.textColor = category.quotes.count == 0 ? KarhooUI.colors.lightGrey : KarhooUI.colors.white
            }
        }
    }
    
    func set(actions: QuoteCategoryBarActions) {
        self.actions = actions
    }
    
    func categoriesChanged(categories: [QuoteCategory], quoteListId: String?) {
        presenter?.categoriesChanged(categories: categories, quoteListId: quoteListId)
    }
    
    func didSelectCategory(_ category: QuoteCategory) {
        hapticGenerator.impactOccurred()
        actions?.didSelectCategory(category)
    }
    
    private func removeExistingLabels() {
        labels.forEach { (label: UILabel) in
            label.removeFromSuperview()
        }
        labels = []
    }
    
    private func addLabels(for categories: [QuoteCategory]) {
        categories.forEach { category in
            let label = createLabel(category: category.categoryName)
            stackView.addArrangedSubview(label)
            _ = [label.centerYAnchor.constraint(equalTo: stackView.centerYAnchor)].map { $0.isActive = true }
            labels.append(label)
        }
        
        setNeedsDisplay()
    }
    
    private func createLabel(category: String) -> RoundedLabel {
        let label = RoundedLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        label.maskToBounds = true
        label.backgroundColor = KarhooUI.colors.lightGrey
        label.text = category.localized.uppercased()
        label.textAlignment = .center
        label.font = KarhooUI.fonts.captionRegular()
        label.textColor = KarhooUI.colors.darkGrey
        
        return label
    }
    
    @objc
    private func labelTapped(recognizer: UIGestureRecognizer) {
        let point = recognizer.location(in: stackView)
        for (index, label) in labels.enumerated() {
            if label.frame.contains(point) {
                presenter?.selected(index: index, animated: true)
                return
            }
        }
        
    }
}
