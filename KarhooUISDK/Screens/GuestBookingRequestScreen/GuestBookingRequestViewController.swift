//
//  GuestBookingRequestViewController.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

final class GuestBookingRequestViewController: UIViewController, BookingRequestView {

    private var didSetupConstraints = false
    private var container: UIView!
    private var exitButton: UIButton!
    private var headerView: GuestCheckoutHeaderView!
    private var passengerDetailsTitle: UILabel!
    private var paymentDetailsTitle: UILabel!
    private var nameInputText: KarhooTextInputView!
    private var surnameInputText: KarhooTextInputView!
    private var emailInputText: KarhooTextInputView!
    private var phoneInputText: KarhooTextInputView!
    private var commentsInputText: KarhooTextInputView!
    private var poiDetailsInputText: KarhooTextInputView!
    private var inputViews: [KarhooInputView] = []
    private var validSet = Set<String>()
    private var passengerDetailsValid: Bool?

    private var addPaymentView: KarhooAddCardView!
    private var termsConditionsView: TermsConditionsView!
    private var baseStackView: BaseStackView!
    private var footerView: UIView!
    private var footerStack: UIStackView!
    private var separatorLine: LineView!
    private var bookingButton: KarhooBookingButtonView!
    private var containerBottomConstraint: NSLayoutConstraint!
    private var presenter: BookingRequestPresenter
    private let drawAnimationTime: Double = 0.45

    private lazy var passengerDetailsView: PassengerDetailsView = {
        let passengerDetailsView = PassengerDetailsView()
        passengerDetailsView.accessibilityIdentifier = "passengerDetailsView"
        passengerDetailsView.actions = self
        return passengerDetailsView
    }()

    var paymentNonce: String?
  
    init(presenter: BookingRequestPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    override func loadView() {
        setUpView()
    }
    
    private func setUpView() {
        view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.accessibilityIdentifier = "container_view"
        container.backgroundColor = .white
        view.addSubview(container)
        
        exitButton = UIButton(type: .custom)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.accessibilityIdentifier = KHBookingRequestViewID.exitButton
        exitButton.setImage(UIImage.uisdkImage("close_button"), for: .normal)
        exitButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        exitButton.imageView?.contentMode = .scaleAspectFit
        container.addSubview(exitButton)
        
        baseStackView = BaseStackView()
        baseStackView.accessibilityIdentifier = "base_stack_view"
        baseStackView.viewSpacing(15.0)
        container.addSubview(baseStackView)
        
        headerView = GuestCheckoutHeaderView()
        baseStackView.addViewToStack(view: headerView)
        
        passengerDetailsTitle = UILabel()
        passengerDetailsTitle.translatesAutoresizingMaskIntoConstraints = false
        passengerDetailsTitle.accessibilityIdentifier = "passenger_details_title_label"
        passengerDetailsTitle.text = UITexts.Booking.guestCheckoutPassengerDetailsTitle
        passengerDetailsTitle.textColor = KarhooUI.colors.guestCheckoutDarkGrey
        passengerDetailsTitle.font = KarhooUI.fonts.getBoldFont(withSize: 20.0)
        baseStackView.addViewToStack(view: passengerDetailsTitle)

        baseStackView.addViewToStack(view: passengerDetailsView)
        setUpFields()

        paymentDetailsTitle = UILabel()
        paymentDetailsTitle.translatesAutoresizingMaskIntoConstraints = false
        paymentDetailsTitle.accessibilityIdentifier = "payment_details_title_label"
        paymentDetailsTitle.text = UITexts.Booking.guestCheckoutPaymentDetailsTitle
        paymentDetailsTitle.textColor = KarhooUI.colors.guestCheckoutDarkGrey
        paymentDetailsTitle.font = KarhooUI.fonts.getBoldFont(withSize: 20.0)
        baseStackView.addViewToStack(view: paymentDetailsTitle)

        addPaymentView = KarhooAddCardView()
        addPaymentView.baseViewController = self
        addPaymentView.actions = self
        baseStackView.addViewToStack(view: addPaymentView)
        
        // Footer view
        footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.accessibilityIdentifier = "footer_view"
        footerView.backgroundColor = .white
        baseStackView.addViewToStack(view: footerView)
        
        footerStack = UIStackView()
        footerStack.translatesAutoresizingMaskIntoConstraints = false
        footerStack.accessibilityIdentifier = "footer_stack_view"
        footerStack.axis = .vertical
        footerStack.spacing = 15.0
        footerView.addSubview(footerStack)
        
        separatorLine = LineView(color: KarhooUI.colors.lightGrey,
                                 accessibilityIdentifier: "booking_request_separator_line")
        footerStack.addArrangedSubview(separatorLine)
        
        bookingButton = KarhooBookingButtonView()
        bookingButton.set(actions: self)
        bookingButton.setDisabledMode()
        footerStack.addArrangedSubview(bookingButton)
        
        termsConditionsView = TermsConditionsView()
        baseStackView.addViewToStack(view: termsConditionsView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        container.addGestureRecognizer(tapGesture)
        
        view.setNeedsUpdateConstraints()
        
        presenter.load(view: self)
    }

    private func setUpFields() {
        nameInputText = KarhooTextInputView(accessibilityIdentifier: "name_input_view")
        nameInputText.delegate = self
        baseStackView.addViewToStack(view: nameInputText)
        inputViews.append(nameInputText)

        surnameInputText = KarhooTextInputView(contentType: .surname,
                                               accessibilityIdentifier: "surname_input_view")

        surnameInputText.delegate = self
        baseStackView.addViewToStack(view: surnameInputText)
        inputViews.append(surnameInputText)

        emailInputText = KarhooTextInputView(contentType: .email,
                                             accessibilityIdentifier: "email_input_view")
        emailInputText.delegate = self
        baseStackView.addViewToStack(view: emailInputText)
        inputViews.append(emailInputText)

        phoneInputText = KarhooTextInputView(contentType: .phone,
                                             accessibilityIdentifier: "phone_input_view")
        phoneInputText.delegate = self
        baseStackView.addViewToStack(view: phoneInputText)
        inputViews.append(phoneInputText)

        commentsInputText = KarhooTextInputView(contentType: .comment,
                                                isOptional: true,
                                                accessibilityIdentifier: "comment_input_view")
        commentsInputText.delegate = self
        baseStackView.addViewToStack(view: commentsInputText)
        inputViews.append(commentsInputText)

        poiDetailsInputText = KarhooTextInputView(contentType: .poiDetails,
                                                  isOptional: true,
                                                  accessibilityIdentifier: "poi_input_view")
        poiDetailsInputText.delegate = self
        poiDetailsInputText.isHidden = true
        baseStackView.addViewToStack(view: poiDetailsInputText)
    }
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            _ = [view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
                 view.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height)].map { $0.isActive = true }
            
            _ = [container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                 container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                 container.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
                 container.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height)]
                .map { $0.isActive = true }
            
            containerBottomConstraint = container.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                                          constant: UIScreen.main.bounds.height)
            containerBottomConstraint.isActive = true
            
            _ = [exitButton.topAnchor.constraint(equalTo: container.topAnchor, constant: view.safeAreaInsets.top),
                 exitButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                 exitButton.widthAnchor.constraint(equalToConstant: 50.0)].map { $0.isActive = true }
            
            _ = [baseStackView.topAnchor.constraint(equalTo: exitButton.bottomAnchor),
                 baseStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                 baseStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                 baseStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor)].map { $0.isActive = true }

            let titleInset: CGFloat = 15.0

            _ = [headerView.leadingAnchor.constraint(equalTo: baseStackView.leadingAnchor, constant: titleInset),
                 headerView.trailingAnchor.constraint(equalTo: baseStackView.trailingAnchor,
                                                      constant: -titleInset)].map { $0.isActive = true }
            
            _ = [passengerDetailsTitle.leadingAnchor.constraint(equalTo: baseStackView.leadingAnchor,
                                                                constant: titleInset),
                 passengerDetailsTitle.trailingAnchor.constraint(equalTo: baseStackView.trailingAnchor,
                                                                 constant: -titleInset)].map { $0.isActive = true }

            passengerDetailsView.pinLeftRightEdegs(to: baseStackView)

            let textInputInset: CGFloat = 30.0
            _ = [nameInputText.leadingAnchor.constraint(equalTo: baseStackView.leadingAnchor,
                                                        constant: textInputInset),
                 nameInputText.trailingAnchor.constraint(equalTo: baseStackView.trailingAnchor,
                                                         constant: -textInputInset)].map { $0.isActive = true }
            
            _ = [surnameInputText.leadingAnchor.constraint(equalTo: baseStackView.leadingAnchor,
                                                           constant: textInputInset),
                 surnameInputText.trailingAnchor.constraint(equalTo: baseStackView.trailingAnchor,
                                                            constant: -textInputInset)].map { $0.isActive = true }
            
            _ = [emailInputText.leadingAnchor.constraint(equalTo: baseStackView.leadingAnchor,
                                                         constant: textInputInset),
                 emailInputText.trailingAnchor.constraint(equalTo: baseStackView.trailingAnchor,
                                                          constant: -textInputInset)].map { $0.isActive = true }
            
            _ = [phoneInputText.leadingAnchor.constraint(equalTo: baseStackView.leadingAnchor,
                                                         constant: textInputInset),
                 phoneInputText.trailingAnchor.constraint(equalTo: baseStackView.trailingAnchor,
                                                          constant: -textInputInset)].map { $0.isActive = true }
            
            _ = [poiDetailsInputText.leadingAnchor.constraint(equalTo: baseStackView.leadingAnchor,
                                                              constant: textInputInset),
                 poiDetailsInputText.trailingAnchor.constraint(equalTo: baseStackView.trailingAnchor,
                                                               constant: -textInputInset)].map { $0.isActive = true }
            
            _ = [commentsInputText.leadingAnchor.constraint(equalTo: baseStackView.leadingAnchor,
                                                            constant: textInputInset),
                 commentsInputText.trailingAnchor.constraint(equalTo: baseStackView.trailingAnchor,
                                                             constant: -textInputInset)].map { $0.isActive = true }
            
            _ = [paymentDetailsTitle.leadingAnchor.constraint(equalTo: baseStackView.leadingAnchor,
                                                              constant: titleInset),
                 paymentDetailsTitle.trailingAnchor.constraint(equalTo: baseStackView.trailingAnchor,
                                                               constant: -titleInset)].map { $0.isActive = true }
            
            _ = [addPaymentView.leadingAnchor.constraint(equalTo: baseStackView.leadingAnchor,
                                                         constant: textInputInset),
                 addPaymentView.trailingAnchor.constraint(equalTo: baseStackView.trailingAnchor,
                                                          constant: -textInputInset)].map { $0.isActive = true }
            
            _ = [footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0),
                 footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                      constant: -10.0)].map { $0.isActive = true }
            
            _ = [footerStack.topAnchor.constraint(equalTo: footerView.topAnchor),
                 footerStack.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
                 footerStack.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
                 footerStack.bottomAnchor.constraint(equalTo: footerView.bottomAnchor)].map { $0.isActive = true }
            
            _ = [termsConditionsView.leadingAnchor.constraint(equalTo: footerStack.leadingAnchor),
                 termsConditionsView.trailingAnchor.constraint(equalTo: footerStack.trailingAnchor)]
                .map { $0.isActive = true }
            
            _ = [separatorLine.heightAnchor.constraint(equalToConstant: 1.0),
                 separatorLine.leadingAnchor.constraint(equalTo: footerStack.leadingAnchor),
                 separatorLine.trailingAnchor.constraint(equalTo: footerStack.trailingAnchor)]
                .map { $0.isActive = true }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBookingRequestView(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        passengerDetailsView.details = PassengerInfo.shared.passengerDetails
    }

    @objc
    private func didTapView() {
        view.endEditing(true)
    }
    
    @objc
    func closePressed() {
        presenter.didPressClose()
    }
    
    func showBookingRequestView(_ show: Bool) {
        if show {
            containerBottomConstraint.constant = 0.0
        } else {
            containerBottomConstraint.constant = UIScreen.main.bounds.height
        }

        UIView.animate(withDuration: drawAnimationTime,
                       animations: { [weak self] in
                        self?.view.layoutIfNeeded()
            }, completion: { [weak self] completed in
            if completed && !show {
                self?.presenter.screenHasFadedOut()
                self?.dismiss(animated: false, completion: nil)
            }
        })
    }
    
    func setRequestingState() {
        disableUserInteraction()
        bookingButton.setRequestingMode()
    }
    
    func setDefaultState() {
        enableUserInteraction()
        bookingButton.setRequestMode()
    }
    
    func setAddFlightDetailsState() {
        enableUserInteraction()
        poiDetailsInputText.isHidden = false
        inputViews.insert(poiDetailsInputText, at: inputViews.count - 1)
    }
    
    func set(quote: Quote) {
        let viewModel = QuoteViewModel(quote: quote)
        headerView.set(viewModel: viewModel)
        termsConditionsView.setBookingTerms(supplier: quote.fleetName,
                                            termsStringURL: quote.termsConditionsUrl)
        addPaymentView.quote = quote
    }
    
    func set(price: String?) {}
    
    func setPrebookState(timeString: String?, dateString: String?) {}
    
    func set(quoteType: String) {}
    
    func set(baseFareExplanationHidden: Bool) {}
    
    func retryAddPaymentMethod() {
        addPaymentView.retryAddPaymentMethod()
    }
    
    func setAsapState(qta: String?) {}
    
    private func enableUserInteraction() {
        exitButton.isUserInteractionEnabled = true
        exitButton.tintColor = KarhooUI.colors.secondary
        addPaymentView.isUserInteractionEnabled = true
    }
    
    private func disableUserInteraction() {
        exitButton.isUserInteractionEnabled = false
        exitButton.tintColor = KarhooUI.colors.medGrey
        addPaymentView.isUserInteractionEnabled = false
    }
    
    final class GuestBookingRequestScreenBuilder: BookingRequestScreenBuilder {
        func buildBookingRequestScreen(quote: Quote,
                                       bookingDetails: BookingDetails,
                                       callback: @escaping ScreenResultCallback<TripInfo>) -> Screen {
            let presenter = GuestBookingRequestPresenter(quote: quote,
                                                         bookingDetails: bookingDetails,
                                                         callback: callback)
            return GuestBookingRequestViewController(presenter: presenter)
        }
    }

    func getPassengerDetails() -> PassengerDetails? {
        return passengerDetailsView.getPassengerDetails()
    }

    func getPaymentNonce() -> String? {
        return self.paymentNonce
    }
    
    func getComments() -> String? {
        return commentsInputText.getIntput()
    }
    
    func getFlightNumber() -> String? {
        return poiDetailsInputText.getIntput()
    }
}

extension GuestBookingRequestViewController: TimePriceViewActions {
    func didPressFareExplanation() {
        presenter.didPressFareExplanation()
    }
}

extension GuestBookingRequestViewController: BookingButtonActions {
    func requestPressed() {
        presenter.bookTripPressed()
    }
    
    func addFlightDetailsPressed() {
        presenter.didPressAddFlightDetails()
    }
}

extension GuestBookingRequestViewController: PassengerDetailsActions {

    func passengerDetailsValid(_ valid: Bool) {
        passengerDetailsValid = valid
        enableBookingButton()
    }
}

extension GuestBookingRequestViewController: KarhooInputViewDelegate {
    func didBecomeInactive(identifier: String) {
        for (index, inputView) in inputViews.enumerated() {
            if inputView.isValid() {
                validSet.insert(inputView.accessibilityIdentifier!)
			} else {
				validSet.remove(inputView.accessibilityIdentifier!)
			}
            if inputView.accessibilityIdentifier == identifier {
                if index != inputViews.count - 1 {
                    inputViews[index + 1].setActive()
                }
            }
        }
		enableBookingButton()
    }
    
    private func enableBookingButton() {
        if passengerDetailsValid == true {
            if addPaymentView.validPayment() {
                bookingButton.setRequestMode()
            } else {
                addPaymentView.showError()
            }
		} else {
			bookingButton.setDisabledMode()
		}
    }
}

extension GuestBookingRequestViewController: PaymentViewActions {
    func didGetNonce(nonce: String) {
        paymentNonce = nonce
        didBecomeInactive(identifier: commentsInputText.accessibilityIdentifier!)
    }
}
