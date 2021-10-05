//
//  FlightDetailsViewController.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

enum AirportFields: Int {
    case flightNumber
}

final class FlightDetailsViewController: UIViewController, FlightDetailsView {
    private let animationTime: Double = 0.5
    private let flightNumberCharacterLimit: Int = 10
    private let driverNotesCharacterLimit: Int = 100

    @IBOutlet private weak var formButtonToBottom: NSLayoutConstraint?
    @IBOutlet private weak var formButton: FormButton?
    @IBOutlet private weak var flightNumberField: KarhooTextField?
    @IBOutlet private weak var additionalInformationField: UITextView?

    private let keyboardObserver: KeyboardSizeProvider = KeyboardSizeProvider.shared
    private let presenter: FlightDetailsPresenter
    private var firstTimeLoading: Bool = true
    private let flightNumberValidator = FlightNumberValidator()

    init(presenter: FlightDetailsPresenter) {
        self.presenter = presenter
        super.init(nibName: "FlightDetailsViewController", bundle: .current)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.load(view: self)
        setDelegates()
        additionalInformationField?.sizeToFit()
        forceLightMode()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if firstTimeLoading == true {
            firstTimeLoading = false
            presenter.screenWillAppear()
        }
    }

    func setUpUI() {
        let button = UIBarButtonItem(title: UITexts.Generic.cancel,
                                     style: .plain,
                                     target: self,
                                     action: #selector(cancelPressed))
        button.tintColor = KarhooUI.colors.darkGrey
        navigationItem.leftBarButtonItem = button

        self.navigationItem.title = UITexts.Airport.airportPickup
        self.formButton?.set(title: UITexts.Booking.requestCar)
        setUpInputFields()
    }

    func startKeyboardListener() {
        keyboardObserver.register(listener: self)
    }

    func set(formButtonEnabled: Bool) {
        if formButtonEnabled {
            formButton?.setEnabledMode()
            return
        }
        formButton?.setDisabledMode()
    }

    func unfocusInputFields() {
        flightNumberField?.setUnFocus()
        additionalInformationField?.resignFirstResponder()
    }

    func updateFlightNumberField(placeHolder: String) {
        flightNumberField?.set(defaultPlaceholder: placeHolder)
    }

    @objc private func cancelPressed() {
        presenter.didPressCancel()
    }

    private func setUpInputFields() {
        flightNumberField?.set(autoCapitalisationType: .allCharacters)
        flightNumberField?.setFocus()
        flightNumberField?.set(defaultPlaceholder: UITexts.Errors.flightNumberValidatorError)
        flightNumberField?.set(identifier: AirportFields.flightNumber.rawValue)
        flightNumberField?.set(animationTime: animationTime)
        flightNumberField?.set(characterLimit: flightNumberCharacterLimit)
        flightNumberField?.set(validator: flightNumberValidator)
        flightNumberField?.set(fieldEventsDelegate: presenter)
    }

    private func setDelegates() {
        flightNumberField?.set(stateDelegate: presenter)
        formButton?.delegate = self
        additionalInformationField?.delegate = self
    }

    deinit {
        keyboardObserver.remove(listener: self)
    }
}

extension FlightDetailsViewController: KeyboardListener {
    func keyboard(updatedHeight: CGFloat) {
        self.formButtonToBottom?.constant = updatedHeight
    }
}

extension FlightDetailsViewController: FormButtonDelegate {
    func formButtonPressed() {
        presenter.didPressContinue()
    }
}

extension FlightDetailsViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        presenter.didSet(additionalInformation: textView.text)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let textViewText = textView.text else {
            return true
        }

        let newLength = textViewText.count + text.count - range.length
        return newLength <= driverNotesCharacterLimit
    }
}
