//
//  FormBookingRequestViewController.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

// swiftlint:disable file_length
public struct KHBookingRequestViewID {
    public static let exitButton = "exit_button"
}

final class FormBookingRequestViewController: UIViewController, BookingRequestView {
    
    private var didSetupConstraints = false
    private var headerView: FormCheckoutHeaderView!
    private var passengerDetailsValid: Bool?
    private var termsConditionsView: TermsConditionsView!
    private var baseStackView: BaseStackView!
    private var footerView: UIView!
    private var footerStack: UIStackView!
    private var containerBottomConstraint: NSLayoutConstraint!
    private var presenter: BookingRequestPresenter
    private let drawAnimationTime: Double = 0.45
    
    private lazy var bookingButton: KarhooBookingButtonView = {
        let bookingButton = KarhooBookingButtonView()
        return bookingButton
    }()
    
    private lazy var commentsInputText: KarhooTextInputView = {
        let commentsInputText = KarhooTextInputView(contentType: .comment,
                                                isOptional: true,
                                                accessibilityIdentifier: "comment_input_view")
        commentsInputText.delegate = self
        return commentsInputText
    }()
    
    private lazy var poiDetailsInputText: KarhooTextInputView = {
        let poiDetailsInputText = KarhooTextInputView(contentType: .poiDetails,
                                                  isOptional: true,
                                                  accessibilityIdentifier: "poi_input_view")
        poiDetailsInputText.delegate = self
        poiDetailsInputText.isHidden = true
        return poiDetailsInputText
    }()
    
    private lazy var passengerDetailsView: PassengerDetailsView = {
        let passengerDetailsView = PassengerDetailsView()
        passengerDetailsView.translatesAutoresizingMaskIntoConstraints = false
        passengerDetailsView.accessibilityIdentifier = "passengerDetailsView"
        passengerDetailsView.actions = self
        return passengerDetailsView
    }()
    
    private lazy var paymentView: PaymentView = {
        let view = KarhooPaymentView()
        return view
    }()
    
    private lazy var passengerDetailsTitle: UILabel = {
        let passengerDetailsTitle = UILabel()
        passengerDetailsTitle.translatesAutoresizingMaskIntoConstraints = false
        passengerDetailsTitle.accessibilityIdentifier = "passenger_details_title_label"
        passengerDetailsTitle.text = UITexts.Booking.guestCheckoutPassengerDetailsTitle
        passengerDetailsTitle.textColor = KarhooUI.colors.infoColor
        passengerDetailsTitle.font = KarhooUI.fonts.getBoldFont(withSize: 20.0)
        return passengerDetailsTitle
    }()
    
    private lazy var paymentDetailsTitle: UILabel = {
        let paymentDetailsTitle = UILabel()
        paymentDetailsTitle.translatesAutoresizingMaskIntoConstraints = false
        paymentDetailsTitle.accessibilityIdentifier = "payment_details_title_label"
        paymentDetailsTitle.text = UITexts.Booking.guestCheckoutPaymentDetailsTitle
        paymentDetailsTitle.textColor = KarhooUI.colors.infoColor
        paymentDetailsTitle.font = KarhooUI.fonts.getBoldFont(withSize: 20.0)
        return paymentDetailsTitle
    }()
    
    private lazy var addPaymentView: KarhooAddCardView = {
        let addPaymentView = KarhooAddCardView()
        addPaymentView.baseViewController = self
        addPaymentView.actions = self
        return addPaymentView
    }()
    
    private lazy var exitButton: UIButton = {
        let exitButton = UIButton(type: .custom)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.accessibilityIdentifier = KHBookingRequestViewID.exitButton
        exitButton.setImage(UIImage.uisdkImage("close_button").withRenderingMode(.alwaysTemplate), for: .normal)
        exitButton.tintColor = KarhooUI.colors.darkGrey
        exitButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        exitButton.imageView?.contentMode = .scaleAspectFit
        
        return exitButton
    }()
    
    private lazy var container: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.accessibilityIdentifier = "container_view"
        container.layer.cornerRadius = 10.0
        container.layer.masksToBounds = true
        container.backgroundColor = .white
        return container
    }()
    
    private lazy var mainStackContainer: UIStackView = {
        let mainStackContainer = UIStackView()
        mainStackContainer.translatesAutoresizingMaskIntoConstraints = false
        mainStackContainer.accessibilityIdentifier = "main_stack_view"
        mainStackContainer.axis = .vertical
        mainStackContainer.spacing = 10.0
        return mainStackContainer
    }()
    
    private lazy var supplierStackContainer: UIStackView = {
        let supplierStackContainer = UIStackView()
        supplierStackContainer.translatesAutoresizingMaskIntoConstraints = false
        supplierStackContainer.accessibilityIdentifier = "supplier_stack_view"
        supplierStackContainer.axis = .horizontal
        supplierStackContainer.alignment = .fill
        supplierStackContainer.distribution = .fill
        return supplierStackContainer
    }()
    
    private lazy var separatorLine: LineView = {
        return LineView(color: KarhooUI.colors.lightGrey,
                                accessibilityIdentifier: "booking_request_separator_line")
    }()
    
    private var timePriceView: KarhooTimePriceView!
    private var mainStackBottomPadding: NSLayoutConstraint!
    
    var paymentNonce: String?
    
    init(presenter: BookingRequestPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        
        bookingButton.set(actions: self)
        termsConditionsView = TermsConditionsView()
        
        setupViewForAuthMethod()
    }
    
    private func setupViewForAuthMethod() {
        switch Karhoo.configuration.authenticationMethod() {
        case .karhooUser:
            setUpUserView()
        default:
            setUpView()
        }
    }
    
    private func setUpUserView() {

        container.addSubview(mainStackContainer)
        mainStackContainer.addArrangedSubview(supplierStackContainer)
        
        headerView = FormCheckoutHeaderView()
        supplierStackContainer.addArrangedSubview(headerView)
        supplierStackContainer.addArrangedSubview(exitButton)
        
        timePriceView = KarhooTimePriceView()
        timePriceView.set(actions: self)
        mainStackContainer.addArrangedSubview(timePriceView)
        
        mainStackContainer.addArrangedSubview(paymentView)
        paymentView.baseViewController = self
        
        mainStackContainer.addArrangedSubview(termsConditionsView)
        mainStackContainer.addArrangedSubview(separatorLine)
        mainStackContainer.addArrangedSubview(bookingButton)
        
        presenter.load(view: self)
    }
    
    private func setUpView() {
        container.addSubview(exitButton)
        
        baseStackView = BaseStackView()
        baseStackView.accessibilityIdentifier = "base_stack_view"
        baseStackView.viewSpacing(15.0)
        container.addSubview(baseStackView)
        
        headerView = FormCheckoutHeaderView()
        baseStackView.addViewToStack(view: headerView)
        
        baseStackView.addViewToStack(view: passengerDetailsTitle)
        baseStackView.addViewToStack(view: passengerDetailsView)
        setUpFields()
        
        baseStackView.addViewToStack(view: paymentDetailsTitle)
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
        
        footerStack.addArrangedSubview(separatorLine)
        
        bookingButton.setDisabledMode()
        footerStack.addArrangedSubview(bookingButton)
        
        baseStackView.addViewToStack(view: termsConditionsView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        container.addGestureRecognizer(tapGesture)
        
        view.setNeedsUpdateConstraints()
        
        presenter.load(view: self)
    }
    
    private func setUpFields() {
        baseStackView.addViewToStack(view: commentsInputText)
        baseStackView.addViewToStack(view: poiDetailsInputText)
    }
    
    override func updateViewConstraints() {
        if didSetupConstraints == false {
            view.anchor(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            container.anchor(leading: view.leadingAnchor, trailing: view.trailingAnchor, width: UIScreen.main.bounds.width)
            
            if presenter.isKarhooUser() {
                setupConstraintsForKarhooUserView()
            } else {
                setupConstraintsForDefault()
            }
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    private func setupConstraintsForKarhooUserView() {
        containerBottomConstraint = container.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                                      constant: UIScreen.main.bounds.height/2)
        containerBottomConstraint.isActive = true
        
        headerView.anchor(top: supplierStackContainer.topAnchor, bottom: supplierStackContainer.bottomAnchor, trailing: exitButton.leadingAnchor, paddingRight: 10)
        
        exitButton.imageEdgeInsets = UIEdgeInsets(top: 17, left: 17, bottom: 17, right: 17)
        exitButton.anchor(top: container.topAnchor, trailing: container.trailingAnchor, width: 50.0)
        
        mainStackContainer.anchor(top: container.topAnchor, leading: container.leadingAnchor, trailing: container.trailingAnchor)
        mainStackBottomPadding = mainStackContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor,
                                                                            constant: -20.0)
        mainStackBottomPadding.isActive = true
        
        termsConditionsView.anchor(leading: mainStackContainer.leadingAnchor, trailing: mainStackContainer.trailingAnchor)
        separatorLine.anchor(leading: mainStackContainer.leadingAnchor, trailing: mainStackContainer.trailingAnchor, height: 1.0)
    }
    
    private func setupConstraintsForDefault() {
        exitButton.anchor(top: container.topAnchor, trailing: container.trailingAnchor, paddingTop: view.safeAreaInsets.top, width: 50.0)
        
        container.anchor(height: UIScreen.main.bounds.height)
        
        containerBottomConstraint = container.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                                      constant: UIScreen.main.bounds.height)
        containerBottomConstraint.isActive = true
        
        baseStackView.anchor(top: exitButton.bottomAnchor, leading: container.leadingAnchor, bottom: container.bottomAnchor, trailing: container.trailingAnchor)
        
        let titleInset: CGFloat = 15.0
        headerView.anchor(leading: baseStackView.leadingAnchor, trailing: baseStackView.trailingAnchor, paddingLeft: titleInset, paddingRight: -titleInset)
        
        passengerDetailsTitle.anchor(leading: baseStackView.leadingAnchor, trailing: baseStackView.trailingAnchor, paddingLeft: titleInset, paddingRight: -titleInset)
        
        passengerDetailsView.pinLeftRightEdegs(to: baseStackView)
        
        let textInputInset: CGFloat = 30.0
        poiDetailsInputText.anchor(leading: baseStackView.leadingAnchor, trailing: baseStackView.trailingAnchor, paddingLeft: textInputInset, paddingRight: -textInputInset)

        commentsInputText.anchor(leading: baseStackView.leadingAnchor, trailing: baseStackView.trailingAnchor, paddingLeft: textInputInset, paddingRight: -textInputInset)
        
        addPaymentView.anchor(leading: baseStackView.leadingAnchor, trailing: baseStackView.trailingAnchor, paddingLeft: textInputInset, paddingRight: -textInputInset)
        
        footerView.anchor(leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingRight: -10.0)
        footerStack.anchor(top: footerView.topAnchor, leading: footerView.leadingAnchor, bottom: footerView.bottomAnchor, trailing: footerView.trailingAnchor)
        
        termsConditionsView.anchor(leading: footerStack.leadingAnchor, trailing: footerStack.trailingAnchor)
        
        separatorLine.anchor(leading: footerStack.leadingAnchor, trailing: footerStack.trailingAnchor, height: 1.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBookingRequestView(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passengerDetailsView.details = initialisePassengerDetails()
    }
    
    private func initialisePassengerDetails() -> PassengerDetails? {
        if PassengerInfo.shared.passengerDetails == nil {
            return PassengerInfo.shared.currentUserAsPassenger()
        } else {
            return PassengerInfo.shared.passengerDetails
        }
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
        if presenter.isKarhooUser() {
            bookingButton.setAddFlightDetailsMode()
        } else {
            poiDetailsInputText.isHidden = false
        }
    }
    
    func set(quote: Quote) {
        let viewModel = QuoteViewModel(quote: quote)
        headerView.set(viewModel: viewModel)
        termsConditionsView.setBookingTerms(supplier: quote.fleet.name,
                                            termsStringURL: quote.fleet.termsConditionsUrl)
        switch Karhoo.configuration.authenticationMethod() {
        case .karhooUser:
            paymentView.quote = quote
        default:
            addPaymentView.quote = quote
        }
    }
    
    func set(price: String?) {
        timePriceView.set(price: price)
    }
    
    func setAsapState(qta: String?) {
        timePriceView.setAsapMode(qta: qta)
    }
    
    func setPrebookState(timeString: String?, dateString: String?) {
        timePriceView.setPrebookMode(timeString: timeString, dateString: dateString)
    }
    
    func set(quoteType: String) {
        timePriceView.set(quoteType: quoteType)
    }
    
    func set(baseFareExplanationHidden: Bool) {
        timePriceView.set(baseFareHidden: baseFareExplanationHidden)
    }
    
    func retryAddPaymentMethod() {
        if presenter.isKarhooUser() {
            paymentView.startRegisterCardFlow()
        } else {
            addPaymentView.startRegisterCardFlow()
        }
    }
    
    private func enableUserInteraction() {
        exitButton.isUserInteractionEnabled = true
        exitButton.tintColor = KarhooUI.colors.secondary
        if presenter.isKarhooUser() {
            paymentView.isUserInteractionEnabled = true
        } else {
            addPaymentView.isUserInteractionEnabled = true
        }
    }
    
    private func disableUserInteraction() {
        exitButton.isUserInteractionEnabled = false
        exitButton.tintColor = KarhooUI.colors.medGrey
        if presenter.isKarhooUser() {
            paymentView.isUserInteractionEnabled = false
        } else {
            addPaymentView.isUserInteractionEnabled = false
        }
    }
    
    final class Builder: BookingRequestScreenBuilder {
        func buildBookingRequestScreen(quote: Quote,
                                       bookingDetails: BookingDetails,
                                       bookingMetadata: [String: Any]?,
                                       callback: @escaping ScreenResultCallback<TripInfo>) -> Screen {
            
            let presenter = FormBookingRequestPresenter(quote: quote,
                                                        bookingDetails: bookingDetails,
                                                        bookingMetadata: bookingMetadata,
                                                        callback: callback)
            return FormBookingRequestViewController(presenter: presenter)
        }
    }
    
    func getPassengerDetails() -> PassengerDetails? {
        return passengerDetailsView.details
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
    
    func paymentView(hidden: Bool) {
        if presenter.isKarhooUser() {
            paymentView.isHidden = hidden
        } else {
            addPaymentView.isHidden = hidden
        }
    }
}

extension FormBookingRequestViewController: TimePriceViewActions {
    func didPressFareExplanation() {
        presenter.didPressFareExplanation()
    }
}

extension FormBookingRequestViewController: BookingButtonActions {
    func requestPressed() {
        presenter.bookTripPressed()
    }
    
    func addFlightDetailsPressed() {
        presenter.didPressAddFlightDetails()
    }
}

extension FormBookingRequestViewController: PassengerDetailsActions {
    func passengerDetailsValid(_ valid: Bool) {
        passengerDetailsValid = valid
        enableBookingButton()
    }
}

extension FormBookingRequestViewController: KarhooInputViewDelegate {
    func didBecomeInactive(identifier: String) {
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

extension FormBookingRequestViewController: PaymentViewActions {
    func didGetNonce(nonce: String) {
        paymentNonce = nonce
        didBecomeInactive(identifier: commentsInputText.accessibilityIdentifier!)
    }
}
