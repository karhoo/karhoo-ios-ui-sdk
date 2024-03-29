//
//  KarhooAddressBarView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import CoreLocation
import KarhooSDK
import UIKit

public struct KHAddressBarViewID {
    public static let pickUpIcon = "pickUp_icon"
    public static let pickupField = "pickUp_field"
    public static let prebookField = "prebook_field"
    public static let destinationField = "destination_field"
    public static let destinationIcon = "destination_icon"
    public static let swapButton = "swap_button"
}

public class KarhooAddressBarView: UIView, AddressBarView {
    
    private var pickUpIcon: UIImageView!
    private var pickupField: KarhooAddressBarFieldView!
    private var fieldsSeparatorLine: LineView!
    private var prebookField: KarhooPrebookFieldView!
    private var prebookSeparator: LineView!
    private var destinationField: KarhooAddressBarFieldView!
    private var destinationIcon: UIImageView!
    private var iconsConnectorLine: LineView!
    private var swapButton: UIButton!
    private var mainViewContainer: UIView!
    private var destinationIconWidthConstraint: NSLayoutConstraint!
    private var destinationIconHeightConstraint: NSLayoutConstraint!
    
    private var presenter: AddressBarPresenter?
    private let dropShadow: Bool
    private let borderLine: Bool
    private let cornerRadious: CGFloat
    private let verticalPadding: CGFloat
    private let horizontalPadding: CGFloat
    private let hidePickUpDestinationConnector: Bool
    private let destinationIconSize: CGFloat = 18.0
    private let hidePrebookButton: Bool

    init(cornerRadious: CGFloat = 5.0,
         borderLine: Bool = false,
         dropShadow: Bool = true,
         verticalPadding: CGFloat = 0.0,
         horizontalPadding: CGFloat = 0.0,
         hidePickUpDestinationConnector: Bool = false,
         hidePrebookButton: Bool = false
    ) {
        self.dropShadow = dropShadow
        self.borderLine = borderLine
        self.cornerRadious = cornerRadious
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
        self.hidePickUpDestinationConnector = hidePickUpDestinationConnector
        self.hidePrebookButton = hidePrebookButton
        super.init(frame: .zero)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        mainViewContainer = UIView()
        mainViewContainer.translatesAutoresizingMaskIntoConstraints = false
        mainViewContainer.accessibilityIdentifier = "main_view"
        mainViewContainer.backgroundColor = .white
        mainViewContainer.layer.cornerRadius = cornerRadious
        mainViewContainer.layer.masksToBounds = true
        if borderLine {
            mainViewContainer.layer.borderColor = KarhooUI.colors.border.cgColor
            mainViewContainer.layer.borderWidth =  UIConstants.Dimension.Border.standardWidth
        }
        addSubview(mainViewContainer)
        
        pickUpIcon = UIImageView()
        pickUpIcon.accessibilityIdentifier = KHAddressBarViewID.pickUpIcon
        pickUpIcon.translatesAutoresizingMaskIntoConstraints = false
        pickUpIcon.image = UIImage.uisdkImage("kh_uisdk_add_pick_up")
        pickUpIcon.contentMode = .scaleAspectFit
        mainViewContainer.addSubview(pickUpIcon)

        destinationIcon = UIImageView()
        destinationIcon.accessibilityIdentifier = KHAddressBarViewID.destinationIcon
        destinationIcon.translatesAutoresizingMaskIntoConstraints = false
        destinationIcon.image = UIImage.uisdkImage("kh_uisdk_add_destination")
        destinationIcon.tintColor = KarhooUI.colors.secondary
        destinationIcon.contentMode = .scaleAspectFit
        mainViewContainer.addSubview(destinationIcon)

        iconsConnectorLine = LineView(color: KarhooUI.colors.border,
                                      width: 1.0,
                                      accessibilityIdentifier: "iconsConnector_line")
        iconsConnectorLine.isHidden = hidePickUpDestinationConnector
        mainViewContainer.addSubview(iconsConnectorLine)

        pickupField = KarhooAddressBarFieldView()
        pickupField.accessibilityIdentifier = KHAddressBarViewID.pickupField
        mainViewContainer.addSubview(pickupField)

        fieldsSeparatorLine = LineView(color: KarhooUI.colors.border,
                                       accessibilityIdentifier: "fieldsSeparator_line")
        mainViewContainer.addSubview(fieldsSeparatorLine)
        
        prebookField = KarhooPrebookFieldView()
        prebookField.isHidden = hidePrebookButton
        prebookField.accessibilityIdentifier = KHAddressBarViewID.prebookField
        prebookField.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        mainViewContainer.addSubview(prebookField)
        
        prebookSeparator = LineView(color: KarhooUI.colors.border,
                                  width: 1.0,
                                  accessibilityIdentifier: "preBookSeparator_line")
        prebookSeparator.isHidden = hidePrebookButton
        mainViewContainer.addSubview(prebookSeparator)

        destinationField = KarhooAddressBarFieldView()
        destinationField.accessibilityIdentifier = KHAddressBarViewID.destinationField
        destinationField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        mainViewContainer.addSubview(destinationField)

        swapButton = UIButton(type: .custom)
        swapButton.accessibilityIdentifier = KHAddressBarViewID.swapButton
        swapButton.accessibilityLabel = UITexts.Accessibility.swapAddresses
        swapButton.translatesAutoresizingMaskIntoConstraints = false
        swapButton.setImage(UIImage.uisdkImage("kh_uisdk_address_swap").withRenderingMode(.alwaysTemplate), for: .normal)
        swapButton.tintColor = KarhooUI.colors.accent
        swapButton.addTarget(self, action: #selector(addressSwapTapped), for: .touchUpInside)
        mainViewContainer.addSubview(swapButton)

        setUpConstraints()

        pickupField.set(actions: self)
        destinationField.set(actions: self)
        prebookField.set(actions: self)
    }
    
    private func setUpConstraints() {
        [
            mainViewContainer.topAnchor.constraint(equalTo: topAnchor, constant: verticalPadding)
                .then { $0.priority = .defaultHigh },
            mainViewContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding)
                .then { $0.priority = .defaultHigh },
            mainViewContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding),
            mainViewContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalPadding)
        ].forEach { $0.isActive = true }
        
        _ = [pickupField.topAnchor.constraint(equalTo: mainViewContainer.topAnchor),
             pickupField.leadingAnchor.constraint(equalTo: pickUpIcon.trailingAnchor, constant: 10.0),
             pickupField.trailingAnchor.constraint(equalTo: mainViewContainer.trailingAnchor,
                                                   constant: -5.0)].map { $0.isActive = true }

        let iconSize: CGFloat = 18.0
        _ = [pickUpIcon.widthAnchor.constraint(equalToConstant: iconSize),
             pickUpIcon.heightAnchor.constraint(equalToConstant: iconSize),
             pickUpIcon.leadingAnchor.constraint(equalTo: mainViewContainer.leadingAnchor, constant: 10.0),
             pickUpIcon.centerYAnchor.constraint(equalTo: pickupField.centerYAnchor)].map { $0.isActive = true }
        pickUpIcon.layer.cornerRadius = iconSize / 2

        _ = [fieldsSeparatorLine.topAnchor.constraint(equalTo: pickupField.bottomAnchor),
             fieldsSeparatorLine.leadingAnchor.constraint(equalTo: pickupField.leadingAnchor),
             fieldsSeparatorLine.trailingAnchor.constraint(equalTo: mainViewContainer.trailingAnchor),
             fieldsSeparatorLine.heightAnchor.constraint(equalToConstant: 1.0)].map { $0.isActive = true }

        _ = [prebookField.centerYAnchor.constraint(equalTo: destinationField.centerYAnchor),
             prebookField.trailingAnchor.constraint(equalTo: mainViewContainer.trailingAnchor)]
            .map { $0.isActive = true }

        _ = [destinationField.topAnchor.constraint(equalTo: fieldsSeparatorLine.bottomAnchor),
             destinationField.bottomAnchor.constraint(equalTo: mainViewContainer.bottomAnchor),
             destinationField.leadingAnchor.constraint(equalTo: pickupField.leadingAnchor),
             destinationField.trailingAnchor.constraint(equalTo: mainViewContainer.trailingAnchor)
            .then { $0.priority = .defaultHigh }
        ].map { $0.isActive = true }
        
        if hidePrebookButton || KarhooUISDKConfigurationProvider.configuration.disablePrebookRides {
            destinationField.topAnchor.constraint(equalTo: fieldsSeparatorLine.bottomAnchor).isActive = true
            destinationField.bottomAnchor.constraint(equalTo: mainViewContainer.bottomAnchor).isActive = true
            destinationField.leadingAnchor.constraint(equalTo: pickupField.leadingAnchor).isActive = true
            destinationField.trailingAnchor.constraint(
                equalTo: mainViewContainer.trailingAnchor,
                constant: -UIConstants.Spacing.medium
            ).isActive = true
        } else {
            _ = [prebookSeparator.trailingAnchor.constraint(equalTo: prebookField.leadingAnchor),
                 prebookSeparator.leadingAnchor.constraint(equalTo: destinationField.trailingAnchor, constant: 5.0),
                 prebookSeparator.topAnchor.constraint(equalTo: fieldsSeparatorLine.bottomAnchor),
                 prebookSeparator.bottomAnchor.constraint(equalTo: mainViewContainer.bottomAnchor)]
                .map { $0.isActive = true }

            _ = [destinationField.topAnchor.constraint(equalTo: fieldsSeparatorLine.bottomAnchor),
                 destinationField.bottomAnchor.constraint(equalTo: mainViewContainer.bottomAnchor),
                 destinationField.leadingAnchor.constraint(equalTo: pickupField.leadingAnchor)
                .then { $0.priority = .defaultHigh }
            ].map { $0.isActive = true }
        }

        destinationIconWidthConstraint = destinationIcon.widthAnchor.constraint(equalToConstant: destinationIconSize)
        destinationIconHeightConstraint = destinationIcon.heightAnchor.constraint(equalToConstant: destinationIconSize)
        destinationIconWidthConstraint.isActive = true
        destinationIconHeightConstraint.isActive = true
        _ = [destinationIcon.centerXAnchor.constraint(equalTo: pickUpIcon.centerXAnchor),
             destinationIcon.centerYAnchor.constraint(equalTo: destinationField.centerYAnchor)]
            .map { $0.isActive = true }
        destinationIcon.layer.cornerRadius = destinationIconSize / 2

        _ = [iconsConnectorLine.centerXAnchor.constraint(equalTo: pickUpIcon.centerXAnchor),
             iconsConnectorLine.topAnchor.constraint(equalTo: pickUpIcon.bottomAnchor),
             iconsConnectorLine.bottomAnchor.constraint(equalTo: destinationIcon.topAnchor)].map { $0.isActive = true }

        let swapButtonSize: CGFloat = 18.0
        _ = [swapButton.widthAnchor.constraint(equalToConstant: swapButtonSize),
             swapButton.heightAnchor.constraint(equalToConstant: swapButtonSize),
             swapButton.centerXAnchor.constraint(equalTo: iconsConnectorLine.centerXAnchor),
             swapButton.centerYAnchor.constraint(equalTo: iconsConnectorLine.centerYAnchor)].map { $0.isActive = true }
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        if dropShadow {
            addOuterShadow()
        }
    }
    
    func set(presenter: AddressBarPresenter?) {
        self.presenter = presenter
    }

    public func set(prebookDate: String, prebookTime: String) {
        prebookField?.set(date: prebookDate, time: prebookTime)
    }

    public func setDefaultPrebookState() {
        prebookField.showDefaultView()
    }

    public func set(pickupDisplayAddress: String?) {
        pickupField.set(
            text: pickupDisplayAddress,
            accessibilityText: UITexts.Accessibility.pickUpAddress + ". " + (pickupDisplayAddress ?? "")
        )

        if pickupDisplayAddress != nil && pickupDisplayAddress != UITexts.AddressBar.addPickup {
            pickUpIcon.image = nil
            pickUpIcon.backgroundColor = KarhooUI.colors.primary
            pickUpIcon.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }
    }

    public func set(destinationDisplayAddress: String?) {
        destinationField.set(
            text: destinationDisplayAddress,
            accessibilityText: UITexts.Accessibility.dropOffAddress + ". " + (destinationDisplayAddress ?? "")
        )
        
        if destinationDisplayAddress != nil && destinationDisplayAddress != UITexts.AddressBar.addDestination {
            destinationIcon.image = nil
            toggleDestinationIconSize(big: false)
            destinationIcon.backgroundColor = KarhooUI.colors.secondary
        }
    }

    public func destinationSetState(disableClearButton: Bool = false) {
        swapButton.isHidden = false
        destinationIcon.image = nil
        toggleDestinationIconSize(big: false)
        destinationIcon.backgroundColor = KarhooUI.colors.secondary
        destinationField?.ordinaryTextColor()
        destinationField?.disableClear(disableClearButton)
    }
    
    private func toggleDestinationIconSize(big: Bool) {
        let ratio: CGFloat = big == true ? 1 : 2
        destinationIconWidthConstraint.constant = destinationIconSize / ratio
        destinationIconHeightConstraint.constant = destinationIconSize / ratio
        destinationIcon.layer.cornerRadius = destinationIconSize / (ratio*2)
    }

    public func pickupNotSetState() {
        swapButton?.isHidden = true
        pickupField?.disableClear(true)
        prebook(isHidden: true)
    }

    public func pickupSetState() {
        prebook(isHidden: false)
    }

    public func destinationNotSetState() {
        swapButton.isHidden = true
        toggleDestinationIconSize(big: true)
        destinationIcon.image = UIImage.uisdkImage("kh_uisdk_add_destination").withRenderingMode(.alwaysTemplate)
        destinationIcon.backgroundColor = .clear
        set(destinationDisplayAddress: UITexts.AddressBar.addDestination)
        destinationField?.ordinaryTextColor()
        destinationField?.disableClear(true)
    }

    public func showPickupSpinner() {
        pickupField.showSpinner()
    }

    public func hidePickupSpinner() {
        pickupField.hideSpinner()
    }

    public func setDisplayTripState() {
        prebook(isHidden: true)
        pickupField?.disable()
        destinationField?.disableClear(true)
        swapButton?.isHidden = true
        hidePickupSpinner()
    }

    private func prebook(isHidden: Bool) {
        if KarhooUISDKConfigurationProvider.configuration.disablePrebookRides {
            prebookField?.isHidden = true
            prebookSeparator?.isHidden = true
        } else {
            prebookField?.isHidden = hidePrebookButton ? true : isHidden
            prebookSeparator?.isHidden = hidePrebookButton ? true : isHidden
        }
    }

    @objc
    private func addressSwapTapped() {
        presenter?.addressSwapSelected()
    }

    private func prepareForRedraw() {
        layer.shadowPath = nil
        setNeedsDisplay()
    }
    
    public func prebookSelected(optionalDoneCallback: (() -> Void)?) {
        presenter?.prebookSelected(optionalDoneCallback: optionalDoneCallback)
    }
}

extension KarhooAddressBarView: AddressBarFieldActions {

    func onFieldSelect(sender: KarhooAddressBarFieldView) {
        switch sender {
        case pickupField: presenter?.addressSelected(type: .pickup)
        case destinationField: presenter?.addressSelected(type: .destination)
        default: break
        }
    }

    func onFieldClear(sender: KarhooAddressBarFieldView) {
        switch sender {
        case pickupField: presenter?.addressCleared(type: .pickup)
        case destinationField: presenter?.addressCleared(type: .destination)
        default: break
        }
    }
    
    func onFieldSet(sender: KarhooAddressBarFieldView) {
        prepareForRedraw()
    }
}

extension KarhooAddressBarView: PreebookFieldActions {

    func prebookSelected() {
        presenter?.prebookSelected()
    }

    func clearedPrebook() {
        presenter?.prebookCleared()
        prebookField.showDefaultView()
        prepareForRedraw()
    }
    
    func prebookSet() {
        prepareForRedraw()
    }
}
