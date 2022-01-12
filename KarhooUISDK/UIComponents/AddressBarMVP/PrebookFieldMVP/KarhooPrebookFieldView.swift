//
//  KarhooPrebookFieldView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

public struct KHPrebookFieldID {
    public static let dateTimeView = "dateTime_view"
    public static let timeLabel = "time_label"
    public static let dateLabel = "date_label"
    public static let closeButton = "close_button"
}

public final class KarhooPrebookFieldView: UIView {

    // MARK: - Nested types

    private enum Constants {
        static var closeButtonSize: CGFloat = 35.0
        static var preBookButtonSize: CGFloat = 35.0
    }

    // MARK: - Properties

    // prebook button
    private var prebookButton: UIButton!
    private var stackContainer: UIStackView!
    // prebook details
    private var dateTimeView: UIView!
    private var dateTimeStackContainer: UIStackView!
    private var timeLabel: UILabel!
    private var dateLabel: UILabel!
    private var closeButton: UIButton!
    
    private weak var actions: PreebookFieldActions?

    // MARK: - Initialization

    init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    
    private func setupHierarchy() {
        addSubview(stackContainer)
        stackContainer.addArrangedSubview(dateTimeView)
        addSubview(dateTimeStackContainer)
        dateTimeStackContainer.addArrangedSubview(timeLabel)
        dateTimeStackContainer.addArrangedSubview(dateLabel)
        dateTimeView.addSubview(closeButton)
        stackContainer.addArrangedSubview(dateTimeView)
        stackContainer.addArrangedSubview(prebookButton)
    }
    
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        setupStackView()
        setupDateTimeView()
        setupDateTimeStackView()
        setupTimeLabel()
        setupDateLabel()
        setupCloseButton()
        setupPrebookButton()
        setupHierarchy()
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        [
            stackContainer.topAnchor.constraint(equalTo: topAnchor),
            stackContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackContainer.bottomAnchor.constraint(equalTo: bottomAnchor)
        ].forEach { $0.isActive = true }

        [
            closeButton.widthAnchor.constraint(equalToConstant: Constants.closeButtonSize),
            closeButton.heightAnchor.constraint(equalToConstant: Constants.closeButtonSize),
            closeButton.leadingAnchor.constraint(equalTo: dateTimeStackContainer.trailingAnchor),
            closeButton.topAnchor.constraint(lessThanOrEqualTo: dateTimeView.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: dateTimeView.trailingAnchor),
            closeButton.bottomAnchor.constraint(lessThanOrEqualTo: dateTimeView.bottomAnchor)
        ].forEach { $0.isActive = true }

        [
            prebookButton.widthAnchor.constraint(equalToConstant: Constants.preBookButtonSize),
            prebookButton.heightAnchor.constraint(equalToConstant: Constants.preBookButtonSize)
        ].forEach { $0.isActive = true }
        
        [
            dateTimeStackContainer.leadingAnchor.constraint(equalTo: dateTimeView.leadingAnchor, constant: 5.0),
            dateTimeStackContainer.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor)
        ]
            .forEach { $0.isActive = true }
    }

    private func setupStackView() {
        stackContainer = UIStackView()
        stackContainer.accessibilityIdentifier = "stackView"
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.axis = .horizontal
    }
    
    private func setupDateTimeView() {
        dateTimeView = UIView()
        dateTimeView.accessibilityIdentifier = KHPrebookFieldID.dateTimeView
        dateTimeView.translatesAutoresizingMaskIntoConstraints = false
        dateTimeView.isHidden = true
        
    }
    
    private func setupDateTimeStackView() {
        dateTimeStackContainer = UIStackView()
        dateTimeStackContainer.accessibilityIdentifier = "dateTime_stackView"
        dateTimeStackContainer.translatesAutoresizingMaskIntoConstraints = false
        dateTimeStackContainer.axis = .vertical
    }
    
    private func setupTimeLabel() {
        timeLabel = buildLabel(
            font: KarhooUI.fonts.footnoteBold(),
            accessibilityIdentifier: KHPrebookFieldID.timeLabel
        )
    }
    
    private func setupDateLabel() {
        dateLabel = buildLabel(
            font: KarhooUI.fonts.footnoteRegular(),
            accessibilityIdentifier: KHPrebookFieldID.dateLabel
        )
    }

    private func buildLabel(font: UIFont, accessibilityIdentifier: String) -> UILabel {
        let label = UILabel()
        label.accessibilityIdentifier = accessibilityIdentifier
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = font
        label.textColor = KarhooUI.colors.darkGrey
        return label
    }
    
    private func setupCloseButton() {
        closeButton = UIButton(type: .custom)
        closeButton.accessibilityIdentifier = KHPrebookFieldID.closeButton
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage.uisdkImage("cross").withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.tintColor = KarhooUI.colors.darkGrey
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.addTarget(self, action: #selector(clearPressed), for: .touchUpInside)
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    private func setupPrebookButton() {
        prebookButton = UIButton(type: .custom)
        prebookButton.translatesAutoresizingMaskIntoConstraints = false
        prebookButton.setImage(UIImage.uisdkImage("fi_calendar").withRenderingMode(.alwaysTemplate), for: .normal)
        prebookButton.tintColor = KarhooUI.colors.accent
        prebookButton.setTitleColor(.black, for: .normal)
        prebookButton.imageView?.contentMode = .scaleAspectFit
        prebookButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        prebookButton.addTarget(self, action: #selector(prebookPressed), for: .touchUpInside)
        prebookButton.accessibilityLabel = UITexts.Booking.prebookRideHint
    }

    // MARK: - Endpoints

    func set(actions: PreebookFieldActions?) {
        self.actions = actions
    }

    func set(date: String, time: String?) {
        dateTimeView.isHidden = false
        prebookButton.isHidden = true
        dateLabel?.text = date
        timeLabel?.text = time
        actions?.prebookSet()
    }

    func showDefaultView() {
        dateTimeView.isHidden = true
        prebookButton.isHidden = false
        actions?.prebookSet()
    }

    // MARK: - Actions

    @objc
    private func clearPressed(_ sender: Any) {
        actions?.clearedPrebook()
    }

    @objc
    private func prebookPressed(_ sender: Any) {
        actions?.prebookSelected()
    }

    
}
