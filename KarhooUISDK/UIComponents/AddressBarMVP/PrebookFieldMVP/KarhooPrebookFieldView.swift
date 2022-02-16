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

    private lazy var prebookButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.uisdkImage("fi_calendar").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = KarhooUI.colors.accent
        button.setTitleColor(.black, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.addTarget(self, action: #selector(prebookPressed), for: .touchUpInside)
        button.accessibilityLabel = UITexts.Booking.prebookRideHint
        return button
    }()

    private lazy var stackContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.accessibilityIdentifier = "stackView"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()

    private lazy var dateTimeView: UIView = {
        let view = UIView()
        view.accessibilityIdentifier = KHPrebookFieldID.dateTimeView
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    private lazy var dateTimeStackContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.accessibilityIdentifier = "dateTime_stackView"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var timeLabel: UILabel = buildLabel(
        font: KarhooUI.fonts.footnoteBold(),
        accessibilityIdentifier: KHPrebookFieldID.timeLabel
    )
    
    private lazy var dateLabel: UILabel = buildLabel(
        font: KarhooUI.fonts.footnoteRegular(),
        accessibilityIdentifier: KHPrebookFieldID.dateLabel
    )
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.accessibilityIdentifier = KHPrebookFieldID.closeButton
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.uisdkImage("cross").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = KarhooUI.colors.text
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(clearPressed), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }()
    
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
        addSubview(dateTimeStackContainer)
        stackContainer.addArrangedSubview(dateTimeView)
        stackContainer.addArrangedSubview(dateTimeView)
        stackContainer.addArrangedSubview(prebookButton)
        dateTimeStackContainer.addArrangedSubview(timeLabel)
        dateTimeStackContainer.addArrangedSubview(dateLabel)
        dateTimeView.addSubview(closeButton)
    }
    
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        setupHierarchy()
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        stackContainer.anchorToSuperview()

        closeButton.anchor(
            leading: dateTimeStackContainer.trailingAnchor,
            trailing: dateTimeView.trailingAnchor,
            width: Constants.closeButtonSize,
            height: Constants.closeButtonSize
        )

        prebookButton.anchor(width: Constants.preBookButtonSize, height: Constants.preBookButtonSize)
        dateTimeStackContainer.anchor(leading: dateTimeView.leadingAnchor, paddingLeft: 5.0)

        [
            closeButton.topAnchor.constraint(lessThanOrEqualTo: dateTimeView.topAnchor),
            closeButton.bottomAnchor.constraint(lessThanOrEqualTo: dateTimeView.bottomAnchor),
            dateTimeStackContainer.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor)
        ].forEach { $0.isActive = true }
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

    // MARK: - Endpoints

    func set(actions: PreebookFieldActions?) {
        self.actions = actions
    }

    func set(date: String, time: String?) {
        dateTimeView.isHidden = false
        prebookButton.isHidden = true
        dateLabel.text = date
        timeLabel.text = time
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
