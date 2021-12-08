//
//  TimePriceView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

final class KarhooTimePriceView: UIView, TimePriceView {

    struct Identifiers {
        static let view = "time_price_view"
        static let mainStack = "main_stack_view"
        static let timeStack = "time_stack_view"
        static let timeLabel = "time_label"
        static let dateLabel = "date_label"
        static let separatorLine = "separator_line"
        static let priceStack = "price_stack_view"
        static let priceLabel = "price_label"
        static let fareView = "fare_view"
        static let baseIcon = "base_fare_icon"
        static let fareButton = "fare_button"
    }
    
    private var mainStackContainer: UIStackView!
    
    private var timeStackContainer: UIStackView!
    private var timeLabel: UILabel!
    private var dateLabel: UILabel!
    private var separatorLine: LineView!
    
    private var priceStackContainer: UIStackView!
    private var priceLabel: UILabel!
    private var fareView: UIView!
    private var quoteTypeLabel: UILabel!
    private var baseFareIcon: UIImageView!
    
    private var fareExplanationButton: UIButton!
    private weak var delegate: TimePriceViewDelegate?

    init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = Identifiers.view
        
        mainStackContainer = UIStackView()
        mainStackContainer.translatesAutoresizingMaskIntoConstraints = false
        mainStackContainer.accessibilityIdentifier = Identifiers.mainStack
        mainStackContainer.distribution = .fillProportionally
        mainStackContainer.alignment = .center
        mainStackContainer.axis = .horizontal
        addSubview(mainStackContainer)
        
        timeStackContainer = UIStackView()
        timeStackContainer.translatesAutoresizingMaskIntoConstraints = false
        timeStackContainer.accessibilityIdentifier = Identifiers.timeStack
        timeStackContainer.distribution = .fill
        timeStackContainer.alignment = .fill
        timeStackContainer.spacing = 1.0
        timeStackContainer.axis = .vertical
        mainStackContainer.addArrangedSubview(timeStackContainer)
        
        timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.accessibilityIdentifier = Identifiers.timeLabel
        timeLabel.font = KarhooUI.fonts.titleBold()
        timeLabel.textColor = KarhooUI.colors.primaryTextColor
        timeLabel.textAlignment = .center
        timeStackContainer.addArrangedSubview(timeLabel)
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.accessibilityIdentifier = Identifiers.dateLabel
        dateLabel.font = KarhooUI.fonts.captionRegular()
        dateLabel.textColor = KarhooUI.colors.medGrey
        dateLabel.textAlignment = .center
        timeStackContainer.addArrangedSubview(dateLabel)
        
        separatorLine = LineView(color: KarhooUI.colors.lightGrey,
                                 width: 1.0,
                                 accessibilityIdentifier: Identifiers.separatorLine)
        mainStackContainer.addArrangedSubview(separatorLine)
        
        priceStackContainer = UIStackView()
        priceStackContainer.translatesAutoresizingMaskIntoConstraints = false
        priceStackContainer.accessibilityIdentifier = Identifiers.priceStack
        priceStackContainer.distribution = .fill
        priceStackContainer.alignment = .center
        priceStackContainer.spacing = 1.0
        priceStackContainer.axis = .vertical
        mainStackContainer.addArrangedSubview(priceStackContainer)
        
        priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.accessibilityIdentifier = Identifiers.priceLabel
        priceLabel.font = KarhooUI.fonts.titleBold()
        priceLabel.textColor = KarhooUI.colors.primaryTextColor
        priceLabel.textAlignment = .center
        priceStackContainer.addArrangedSubview(priceLabel)
        
        fareView = UIView()
        fareView.translatesAutoresizingMaskIntoConstraints = false
        fareView.accessibilityIdentifier = Identifiers.fareView
        priceStackContainer.addArrangedSubview(fareView)
        
        quoteTypeLabel = UILabel()
        quoteTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        quoteTypeLabel.accessibilityIdentifier = Identifiers.dateLabel
        quoteTypeLabel.font = KarhooUI.fonts.captionRegular()
        quoteTypeLabel.textColor = KarhooUI.colors.primaryTextColor
        quoteTypeLabel.textAlignment = .center
        fareView.addSubview(quoteTypeLabel)
        
        baseFareIcon = UIImageView(image: UIImage.uisdkImage("baseFare").withRenderingMode(.alwaysTemplate))
        baseFareIcon.translatesAutoresizingMaskIntoConstraints = false
        baseFareIcon.accessibilityIdentifier = Identifiers.baseIcon
        baseFareIcon.tintColor = KarhooUI.colors.primary
        fareView.addSubview(baseFareIcon)
        
        fareExplanationButton = UIButton(type: .custom)
        fareExplanationButton.translatesAutoresizingMaskIntoConstraints = false
        fareExplanationButton.accessibilityIdentifier = Identifiers.fareButton
        fareExplanationButton.addTarget(self, action: #selector(didPressFareExplanation), for: .touchUpInside)
        addSubview(fareExplanationButton)
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        _ = [mainStackContainer.topAnchor.constraint(equalTo: topAnchor),
             mainStackContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
             mainStackContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
             mainStackContainer.bottomAnchor.constraint(equalTo: bottomAnchor)].map { $0.isActive = true }
        
        _ = [separatorLine.topAnchor.constraint(equalTo: timeStackContainer.topAnchor),
             separatorLine.bottomAnchor.constraint(equalTo: timeStackContainer.bottomAnchor)].map { $0.isActive = true }
        
        _ = [quoteTypeLabel.topAnchor.constraint(equalTo: fareView.topAnchor),
             quoteTypeLabel.leadingAnchor.constraint(equalTo: fareView.leadingAnchor),
             quoteTypeLabel.bottomAnchor.constraint(equalTo: fareView.bottomAnchor)].map { $0.isActive = true }
                    
        _ = [baseFareIcon.leadingAnchor.constraint(equalTo: quoteTypeLabel.trailingAnchor, constant: 4.0),
             baseFareIcon.centerYAnchor.constraint(equalTo: quoteTypeLabel.centerYAnchor),
             baseFareIcon.trailingAnchor.constraint(equalTo: fareView.trailingAnchor),
             baseFareIcon.heightAnchor.constraint(equalToConstant: 12.0),
             baseFareIcon.widthAnchor.constraint(equalToConstant: 12.0)].map { $0.isActive = true }
        
        _ = [fareExplanationButton.topAnchor.constraint(equalTo: topAnchor),
             fareExplanationButton.trailingAnchor.constraint(equalTo: trailingAnchor),
             fareExplanationButton.bottomAnchor.constraint(equalTo: bottomAnchor),
             fareExplanationButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2)]
            .map { $0.isActive = true }
    }
    
    func set(actions: TimePriceViewDelegate) {
        self.delegate = actions
    }

    func set(price: String?) {
        priceLabel?.text = price
    }

    func setPrebookMode(timeString: String?, dateString: String?) {
        dateLabel?.text = dateString
        timeLabel?.text = timeString
    }

    func setAsapMode(qta: String?) {
        timeLabel?.text = qta
        dateLabel?.text = UITexts.Generic.pickupTime
    }

    func set(baseFareHidden: Bool) {
        baseFareIcon?.isHidden = baseFareHidden
        fareExplanationButton?.isHidden = baseFareHidden
    }

    func set(quoteType: String) {
        quoteTypeLabel?.text = quoteType
    }

    func set(fareExplanationHidden: Bool) {
        fareExplanationButton?.isHidden = fareExplanationHidden
    }

    @objc
    private func didPressFareExplanation() {
        delegate?.didPressFareExplanation()
    }
}
