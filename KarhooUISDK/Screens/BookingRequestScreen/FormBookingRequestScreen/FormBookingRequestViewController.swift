//
//  FormBookingRequestViewController.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

final class FormBookingRequestViewController: UIViewController, BookingRequestView {
    
    private var didSetupConstraints = false
    private var headerView: FormCheckoutHeaderView!
    private var passengerDetailsValid: Bool?
    private var termsConditionsView: TermsConditionsView!
    private var footerView: UIView!
    private var footerStack: UIStackView!
    private var containerBottomConstraint: NSLayoutConstraint!
    private var presenter: BookingRequestPresenter
    private let drawAnimationTime: Double = 0.45
    
    private lazy var bookingButton: KarhooBookingButtonView = {
        let bookingButton = KarhooBookingButtonView()
        bookingButton.anchor(height: 55.0)
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
    
    // TODO: leave these lines commented here until next related story (will be moved in a different place,
    // the code can be referenced from here
    
//    private lazy var passengerDetailsView: PassengerDetailsView = {
//        let passengerDetailsView = PassengerDetailsView()
//        passengerDetailsView.translatesAutoresizingMaskIntoConstraints = false
//        passengerDetailsView.accessibilityIdentifier = "passengerDetailsView"
//        passengerDetailsView.actions = self
//        return passengerDetailsView
//    }()
//
//    private lazy var passengerDetailsTitle: UILabel = {
//        let passengerDetailsTitle = UILabel()
//        passengerDetailsTitle.translatesAutoresizingMaskIntoConstraints = false
//        passengerDetailsTitle.accessibilityIdentifier = "passenger_details_title_label"
//        passengerDetailsTitle.text = UITexts.Booking.guestCheckoutPassengerDetailsTitle
//        passengerDetailsTitle.textColor = KarhooUI.colors.infoColor
//        passengerDetailsTitle.font = KarhooUI.fonts.getBoldFont(withSize: 20.0)
//        return passengerDetailsTitle
//    }()
//
//    private lazy var paymentDetailsTitle: UILabel = {
//        let paymentDetailsTitle = UILabel()
//        paymentDetailsTitle.translatesAutoresizingMaskIntoConstraints = false
//        paymentDetailsTitle.accessibilityIdentifier = "payment_details_title_label"
//        paymentDetailsTitle.text = UITexts.Booking.guestCheckoutPaymentDetailsTitle
//        paymentDetailsTitle.textColor = KarhooUI.colors.infoColor
//        paymentDetailsTitle.font = KarhooUI.fonts.getBoldFont(withSize: 20.0)
//        return paymentDetailsTitle
//    }()
//
//    private lazy var addPaymentView: KarhooAddCardView = {
//        let addPaymentView = KarhooAddCardView()
//        addPaymentView.baseViewController = self
//        addPaymentView.actions = self
//        return addPaymentView
//    }()
    
    private lazy var backButton: UIButton = {
        let backButton = UIButton(type: .custom)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.accessibilityIdentifier = "back_button"
        backButton.setImage(UIImage.uisdkImage("close_button").withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = KarhooUI.colors.darkGrey
        backButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        backButton.imageView?.contentMode = .scaleAspectFit
        
        return backButton
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
    
    private lazy var baseStackView: BaseStackView = {
       let baseStackView = BaseStackView()
        baseStackView.translatesAutoresizingMaskIntoConstraints = false
        baseStackView.accessibilityIdentifier = "base_stack_view"
        baseStackView.viewSpacing(15.0)
        return baseStackView
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
    
    private lazy var timePriceView: KarhooTimePriceView = {
        let timePriceView = KarhooTimePriceView()
        timePriceView.set(actions: self)
        return timePriceView
    }()
    
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
        
        setUpView()
    }
    
    private func setUpView() {
        container.addSubview(backButton)
        container.addSubview(baseStackView)
        
        headerView = FormCheckoutHeaderView()
        baseStackView.addViewToStack(view: headerView)
        
        setUpFields()
        
        baseStackView.addViewToStack(view: termsConditionsView)
        
        // Footer view
        footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.accessibilityIdentifier = "footer_view"
        footerView.backgroundColor = .white
        container.addSubview(footerView)
        
        footerStack = UIStackView()
        footerStack.translatesAutoresizingMaskIntoConstraints = false
        footerStack.accessibilityIdentifier = "footer_stack_view"
        footerStack.axis = .vertical
        footerStack.spacing = 15.0
        footerView.addSubview(footerStack)
        
        bookingButton.setDisabledMode()
        footerStack.addArrangedSubview(bookingButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        container.addGestureRecognizer(tapGesture)
        
        view.setNeedsUpdateConstraints()
        
        presenter.load(view: self)
        
        commentsInputText.isHidden = presenter.isKarhooUser()
    }
    
    private func setUpFields() {
//        baseStackView.addViewToStack(view: passengerDetailsTitle)
//        baseStackView.addViewToStack(view: passengerDetailsView)
//        baseStackView.addViewToStack(view: paymentDetailsTitle)
//        baseStackView.addViewToStack(view: addPaymentView)
        
        baseStackView.addViewToStack(view: commentsInputText)
        baseStackView.addViewToStack(view: poiDetailsInputText)
    }
    
    override func updateViewConstraints() {
        if didSetupConstraints == false {
            setupConstraintsForDefault()
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    private func setupConstraintsForDefault() {
        view.anchor(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        container.anchor(leading: view.leadingAnchor, trailing: view.trailingAnchor, width: UIScreen.main.bounds.width)
        
        backButton.anchor(top: container.topAnchor, trailing: container.trailingAnchor, paddingTop: view.safeAreaInsets.top, width: 50.0)
        
        container.anchor(height: UIScreen.main.bounds.height)
        
        containerBottomConstraint = container.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                                      constant: UIScreen.main.bounds.height)
        containerBottomConstraint.isActive = true
        
        baseStackView.anchor(top: backButton.bottomAnchor, leading: container.leadingAnchor, bottom: footerView.topAnchor, trailing: container.trailingAnchor)
        
        let titleInset: CGFloat = 15.0
        headerView.anchor(leading: baseStackView.leadingAnchor, trailing: baseStackView.trailingAnchor, paddingLeft: titleInset, paddingRight: titleInset)

        let textInputInset: CGFloat = 30.0
        poiDetailsInputText.anchor(leading: baseStackView.leadingAnchor, trailing: baseStackView.trailingAnchor, paddingLeft: textInputInset, paddingRight: textInputInset)

        commentsInputText.anchor(leading: baseStackView.leadingAnchor, trailing: baseStackView.trailingAnchor, paddingLeft: textInputInset, paddingRight: textInputInset)
        
        footerView.anchor(leading: view.leadingAnchor, bottom: container.bottomAnchor, trailing: view.trailingAnchor, paddingBottom: 20.0, paddingRight: 10.0)
        footerStack.anchor(top: footerView.topAnchor, leading: footerView.leadingAnchor, bottom: footerView.bottomAnchor, trailing: footerView.trailingAnchor)
        
        termsConditionsView.anchor(leading: baseStackView.leadingAnchor, trailing: baseStackView.trailingAnchor)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBookingRequestView(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        passengerDetailsView.details = initialisePassengerDetails()
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
//        addPaymentView.quote = quote
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
//        addPaymentView.startRegisterCardFlow()
    }
    
    private func enableUserInteraction() {
        backButton.isUserInteractionEnabled = true
        backButton.tintColor = KarhooUI.colors.secondary
//        addPaymentView.isUserInteractionEnabled = true
    }
    
    private func disableUserInteraction() {
        backButton.isUserInteractionEnabled = false
        backButton.tintColor = KarhooUI.colors.medGrey
//        addPaymentView.isUserInteractionEnabled = false
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
//        return passengerDetailsView.details
        return nil
    }
    
    func getPaymentNonce() -> String? {
        return self.paymentNonce
    }
    
    func getComments() -> String? {
        return commentsInputText.getInput()
    }
    
    func getFlightNumber() -> String? {
        return poiDetailsInputText.getInput()
    }
    
    func paymentView(hidden: Bool) {
//        addPaymentView.isHidden = hidden
//        paymentDetailsTitle.isHidden = hidden
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
//            if addPaymentView.validPayment() {
//                bookingButton.setRequestMode()
//            } else {
//                addPaymentView.showError()
//            }
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
