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
    
    init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        stackContainer = UIStackView()
        stackContainer.accessibilityIdentifier = "stackView"
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.axis = .horizontal
        addSubview(stackContainer)
        
        dateTimeView = UIView()
        dateTimeView.accessibilityIdentifier = KHPrebookFieldID.dateTimeView
        dateTimeView.translatesAutoresizingMaskIntoConstraints = false
        dateTimeView.isHidden = true
        stackContainer.addArrangedSubview(dateTimeView)
        
        dateTimeStackContainer = UIStackView()
        dateTimeStackContainer.accessibilityIdentifier = "dateTime_stackView"
        dateTimeStackContainer.translatesAutoresizingMaskIntoConstraints = false
        dateTimeStackContainer.axis = .vertical
        addSubview(dateTimeStackContainer)
        
        timeLabel = UILabel()
        timeLabel.accessibilityIdentifier = KHPrebookFieldID.timeLabel
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textAlignment = .center
        timeLabel.font = KarhooUI.fonts.footnoteBold()
        timeLabel.textColor = KarhooUI.colors.darkGrey
        dateTimeStackContainer.addArrangedSubview(timeLabel)
        
        dateLabel = UILabel()
        dateLabel.accessibilityIdentifier = KHPrebookFieldID.dateLabel
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textAlignment = .center
        dateLabel.font = KarhooUI.fonts.footnoteRegular()
        dateLabel.textColor = KarhooUI.colors.darkGrey
        dateTimeStackContainer.addArrangedSubview(dateLabel)
        
        closeButton = UIButton(type: .custom)
        closeButton.accessibilityIdentifier = KHPrebookFieldID.closeButton
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage.uisdkImage("cross").withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.tintColor = KarhooUI.colors.darkGrey
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.addTarget(self, action: #selector(clearPressed), for: .touchUpInside)
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        dateTimeView.addSubview(closeButton)
        
        prebookButton = UIButton(type: .custom)
        prebookButton.translatesAutoresizingMaskIntoConstraints = false
        prebookButton.setImage(UIImage.uisdkImage("fi_calendar").withRenderingMode(.alwaysTemplate), for: .normal)
        prebookButton.tintColor = KarhooUI.colors.accent
        prebookButton.setTitleColor(.black, for: .normal)
        prebookButton.imageView?.contentMode = .scaleAspectFit
        prebookButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        prebookButton.addTarget(self, action: #selector(prebookPressed), for: .touchUpInside)
        prebookButton.accessibilityHint = UITexts.Booking.prebookRideHint

        stackContainer.addArrangedSubview(dateTimeView)
        stackContainer.addArrangedSubview(prebookButton)
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        
        _ = [stackContainer.topAnchor.constraint(equalTo: topAnchor),
             stackContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
             stackContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
             stackContainer.bottomAnchor.constraint(equalTo: bottomAnchor)].map { $0.isActive = true }
        
        let closeButtonSize: CGFloat = 35.0
        _ = [closeButton.widthAnchor.constraint(equalToConstant: closeButtonSize),
             closeButton.heightAnchor.constraint(equalToConstant: closeButtonSize),
             closeButton.leadingAnchor.constraint(equalTo: dateTimeStackContainer.trailingAnchor),
             closeButton.topAnchor.constraint(lessThanOrEqualTo: dateTimeView.topAnchor),
             closeButton.trailingAnchor.constraint(equalTo: dateTimeView.trailingAnchor),
             closeButton.bottomAnchor.constraint(lessThanOrEqualTo: dateTimeView.bottomAnchor)]
            .map { $0.isActive = true }
        
        let preBookButtonSize: CGFloat = 35.0
        _ = [prebookButton.widthAnchor.constraint(equalToConstant: preBookButtonSize),
             prebookButton.heightAnchor.constraint(equalToConstant: preBookButtonSize)].map { $0.isActive = true }
        
        _ = [dateTimeStackContainer.leadingAnchor.constraint(equalTo: dateTimeView.leadingAnchor, constant: 5.0),
             dateTimeStackContainer.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor)]
            .map { $0.isActive = true }
    }

    func set(actions: PreebookFieldActions?) {
        self.actions = actions
    }

    @objc
    private func clearPressed(_ sender: Any) {
        actions?.clearedPrebook()
    }

    @objc
    private func prebookPressed(_ sender: Any) {
        actions?.prebookSelected()
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
}
