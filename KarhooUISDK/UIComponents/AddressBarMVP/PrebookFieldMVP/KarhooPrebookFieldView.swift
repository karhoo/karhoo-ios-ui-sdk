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
        static var preBookButtonSize: CGFloat = 34.0
    }

    // MARK: - Properties

    private lazy var prebookButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.uisdkImage("kh_uisdk_calendar").withRenderingMode(.alwaysTemplate), for: .normal)
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

    private lazy var dateSelectedStack = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.spacing = UIConstants.Spacing.xSmall
        $0.axis = .horizontal
    }

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
        button.setImage(UIImage.uisdkImage("kh_uisdk_cross_in_circle"), for: .normal)
        button.addTarget(self, action: #selector(clearPressed), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = KarhooUI.colors.textLabel
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
        stackContainer.addArrangedSubview(dateSelectedStack)
        stackContainer.addArrangedSubview(prebookButton)

        dateSelectedStack.addArrangedSubview(dateTimeStackContainer)
        dateSelectedStack.addArrangedSubview(closeButton)
        dateTimeStackContainer.addArrangedSubview(timeLabel)
        dateTimeStackContainer.addArrangedSubview(dateLabel)
    }
    
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        setupHierarchy()
        setUpConstraints()

        dateTimeStackContainer.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(prebookPressed)
            )
        )
    }
    
    private func setUpConstraints() {
        stackContainer.anchorToSuperview(
            paddingLeading: UIConstants.Spacing.xSmall,
            paddingTrailing: UIConstants.Spacing.small
        )
        closeButton.setDimensions(
            height: UIConstants.Dimension.Icon.standard,
            width: UIConstants.Dimension.Icon.standard
        )
        prebookButton.setDimensions(
            height: Constants.preBookButtonSize,
            width: Constants.preBookButtonSize
        )
    }

    private func buildLabel(font: UIFont, accessibilityIdentifier: String) -> UILabel {
        let label = UILabel()
        label.accessibilityIdentifier = accessibilityIdentifier
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = font
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.textColor = KarhooUI.colors.text
        return label
    }

    // MARK: - Endpoints

    func set(actions: PreebookFieldActions?) {
        self.actions = actions
    }

    func set(date: String, time: String?) {
        dateSelectedStack.isHidden = false
        prebookButton.isHidden = true
        dateLabel.text = date
        timeLabel.text = time
        actions?.prebookSet()
    }

    func showDefaultView() {
        dateSelectedStack.isHidden = true
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
