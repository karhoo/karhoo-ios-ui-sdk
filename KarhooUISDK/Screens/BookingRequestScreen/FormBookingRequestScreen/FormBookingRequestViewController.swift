//
//  FormBookingRequestViewController.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

public struct KHBookingRequestViewID {
    public static let exitBackgroundButton = "exit_background_button"
    public static let exitButton = "exit_button"
}

final class FormBookingRequestViewController: UIViewController, BookingRequestView {

    private var didSetupConstraints = false
    private var container: UIView!
    private var exitButton: UIButton!
    private var headerView: FormCheckoutHeaderView!
    private var passengerDetailsTitle: UILabel!
    private var paymentDetailsTitle: UILabel!
    private var commentsInputText: KarhooTextInputView!
    private var poiDetailsInputText: KarhooTextInputView!
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
        passengerDetailsView.translatesAutoresizingMaskIntoConstraints = false
        passengerDetailsView.accessibilityIdentifier = "passengerDetailsView"
        passengerDetailsView.actions = self
        return passengerDetailsView
    }()
    
    private lazy var paymentView: PaymentView = {
        let view = KarhooPaymentView()
        return view
    }()
    
    private var exitBackgroundButton: UIView!
    private var mainStackContainer: UIStackView!
    private var mainStackBottomPadding: NSLayoutConstraint!
    
    private var supplierStackContainer: UIStackView!
    private var supplierView: SupplierView!
    
    private var timePriceView: KarhooTimePriceView!


    var paymentNonce: String?
  
    init(presenter: BookingRequestPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    override func loadView() {
        switch Karhoo.configuration.authenticationMethod() {
        case .karhooUser:
            setUpUserView()
        default:
            setUpView()
        }
    }
    
    private func setUpUserView() {
        view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        exitBackgroundButton = UIView()
        exitBackgroundButton.translatesAutoresizingMaskIntoConstraints = false
        exitBackgroundButton.accessibilityIdentifier = KHBookingRequestViewID.exitBackgroundButton
        exitBackgroundButton.backgroundColor = .clear
        view.addSubview(exitBackgroundButton)
        
        let closeTapGesture = UITapGestureRecognizer(target: self, action: #selector(closePressed))
        exitBackgroundButton.addGestureRecognizer(closeTapGesture)
        
        container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.accessibilityIdentifier = "container_view"
        container.layer.cornerRadius = 10.0
        container.layer.masksToBounds = true
        container.backgroundColor = .white
        view.addSubview(container)
        
        mainStackContainer = UIStackView()
        mainStackContainer.translatesAutoresizingMaskIntoConstraints = false
        mainStackContainer.accessibilityIdentifier = "main_stack_view"
        mainStackContainer.axis = .vertical
        mainStackContainer.spacing = 10.0
        container.addSubview(mainStackContainer)
        
        supplierStackContainer = UIStackView()
        supplierStackContainer.translatesAutoresizingMaskIntoConstraints = false
        supplierStackContainer.accessibilityIdentifier = "supplier_stack_view"
        supplierStackContainer.axis = .horizontal
        supplierStackContainer.alignment = .fill
        supplierStackContainer.distribution = .fill
        mainStackContainer.addArrangedSubview(supplierStackContainer)
        
        supplierView = SupplierView()
        supplierStackContainer.addArrangedSubview(supplierView)
        
        exitButton = UIButton(type: .custom)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.accessibilityIdentifier = KHBookingRequestViewID.exitButton
        exitButton.setImage(UIImage.uisdkImage("cross").withRenderingMode(.alwaysTemplate), for: .normal)
        exitButton.tintColor = KarhooUI.colors.darkGrey
        exitButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        exitButton.imageEdgeInsets = UIEdgeInsets(top: 17, left: 17, bottom: 17, right: 17)
        exitButton.imageView?.contentMode = .scaleAspectFit
        supplierStackContainer.addArrangedSubview(exitButton)
        
        timePriceView = KarhooTimePriceView()
        timePriceView.set(actions: self)
        mainStackContainer.addArrangedSubview(timePriceView)
        
        mainStackContainer.addArrangedSubview(paymentView)
        paymentView.baseViewController = self
        
        termsConditionsView = TermsConditionsView()
        mainStackContainer.addArrangedSubview(termsConditionsView)
        
        separatorLine = LineView(color: KarhooUI.colors.lightGrey,
                                 accessibilityIdentifier: "booking_request_separator_line")
        mainStackContainer.addArrangedSubview(separatorLine)
        
        bookingButton = KarhooBookingButtonView()
        bookingButton.set(actions: self)
        mainStackContainer.addArrangedSubview(bookingButton)
        
        presenter.load(view: self, karhooUser: true)
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
        
        headerView = FormCheckoutHeaderView()
        baseStackView.addViewToStack(view: headerView)
        
        passengerDetailsTitle = UILabel()
        passengerDetailsTitle.translatesAutoresizingMaskIntoConstraints = false
        passengerDetailsTitle.accessibilityIdentifier = "passenger_details_title_label"
        passengerDetailsTitle.text = UITexts.Booking.guestCheckoutPassengerDetailsTitle
        passengerDetailsTitle.textColor = KarhooUI.colors.infoColor
        passengerDetailsTitle.font = KarhooUI.fonts.getBoldFont(withSize: 20.0)
        baseStackView.addViewToStack(view: passengerDetailsTitle)

        baseStackView.addViewToStack(view: passengerDetailsView)
        setUpFields()

        paymentDetailsTitle = UILabel()
        paymentDetailsTitle.translatesAutoresizingMaskIntoConstraints = false
        paymentDetailsTitle.accessibilityIdentifier = "payment_details_title_label"
        paymentDetailsTitle.text = UITexts.Booking.guestCheckoutPaymentDetailsTitle
        paymentDetailsTitle.textColor = KarhooUI.colors.infoColor
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
        
        presenter.load(view: self, karhooUser: false)
    }

    private func setUpFields() {
        commentsInputText = KarhooTextInputView(contentType: .comment,
                                                isOptional: true,
                                                accessibilityIdentifier: "comment_input_view")
        commentsInputText.delegate = self
        baseStackView.addViewToStack(view: commentsInputText)

        poiDetailsInputText = KarhooTextInputView(contentType: .poiDetails,
                                                  isOptional: true,
                                                  accessibilityIdentifier: "poi_input_view")
        poiDetailsInputText.delegate = self
        poiDetailsInputText.isHidden = true
        baseStackView.addViewToStack(view: poiDetailsInputText)
    }
    
    override func updateViewConstraints() {
        switch Karhoo.configuration.authenticationMethod() {
        case .karhooUser:
            if !didSetupConstraints {
                _ = [view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
                     view.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height)].map { $0.isActive = true }
                
                _ = [exitBackgroundButton.topAnchor.constraint(equalTo: view.topAnchor),
                     exitBackgroundButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                     exitBackgroundButton.bottomAnchor.constraint(equalTo: container.topAnchor)].map { $0.isActive = true }
                
                _ = [container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                     container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                     container.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)]
                    .map { $0.isActive = true }
                
                containerBottomConstraint = container.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                                              constant: UIScreen.main.bounds.height / 2)
                containerBottomConstraint.isActive = true
                
                _ = [supplierView.topAnchor.constraint(equalTo: supplierStackContainer.topAnchor),
                     supplierView.bottomAnchor.constraint(equalTo: supplierStackContainer.bottomAnchor),
                     supplierView.trailingAnchor.constraint(equalTo: exitButton.leadingAnchor, constant: 10)]
                    .map { $0.isActive = true }
                
                _ = [exitButton.widthAnchor.constraint(equalToConstant: 50.0)].map { $0.isActive = true }
                
                _ = [mainStackContainer.topAnchor.constraint(equalTo: container.topAnchor),
                     mainStackContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                     mainStackContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor)]
                    .map { $0.isActive = true }
                
                mainStackBottomPadding = mainStackContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor,
                                                                                    constant: -20.0)
                mainStackBottomPadding.isActive = true

                _ = [termsConditionsView.leadingAnchor.constraint(equalTo: mainStackContainer.leadingAnchor),
                     termsConditionsView.trailingAnchor.constraint(equalTo: mainStackContainer.trailingAnchor)]
                    .map { $0.isActive = true }
                
                _ = [separatorLine.heightAnchor.constraint(equalToConstant: 1.0),
                     separatorLine.leadingAnchor.constraint(equalTo: mainStackContainer.leadingAnchor),
                     separatorLine.trailingAnchor.constraint(equalTo: mainStackContainer.trailingAnchor)]
                    .map { $0.isActive = true }
                
                didSetupConstraints = true
            }
            
            super.updateViewConstraints()
        default:
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
        poiDetailsInputText.isHidden = false
    }
    
    func set(quote: Quote) {
        switch Karhoo.configuration.authenticationMethod() {
        case .karhooUser:
                let viewModel = QuoteViewModel(quote: quote)
                supplierView.set(viewModel: viewModel)
                paymentView.quote = quote
                termsConditionsView.setBookingTerms(supplier: quote.fleet.name,
                                                    termsStringURL: quote.fleet.termsConditionsUrl)
        default:
            let viewModel = QuoteViewModel(quote: quote)
            headerView.set(viewModel: viewModel)
            termsConditionsView.setBookingTerms(supplier: quote.fleet.name,
                                                termsStringURL: quote.fleet.termsConditionsUrl)
            addPaymentView.quote = quote
        }
    }
    
    func set(price: String?) {
        timePriceView.set(price: price)
    }
    
    func setAsapState(qta: String?) {
        timePriceView.setAsapMode(qta: qta)
    }
    
    func setPrebookState(timeString: String?, dateString: String?) {}
    
    func set(quoteType: String) {}
    
    func set(baseFareExplanationHidden: Bool) {}
    
    func retryAddPaymentMethod() {
        addPaymentView.startRegisterCardFlow()
    }
    
    private func enableUserInteraction() {
        exitButton.isUserInteractionEnabled = true
        exitButton.tintColor = KarhooUI.colors.secondary
        switch Karhoo.configuration.authenticationMethod() {
        case .karhooUser:
            paymentView.isUserInteractionEnabled = true
        default:
            addPaymentView.isUserInteractionEnabled = true
        }
    }
    
    private func disableUserInteraction() {
        exitButton.isUserInteractionEnabled = false
        exitButton.tintColor = KarhooUI.colors.medGrey
        switch Karhoo.configuration.authenticationMethod() {
        case .karhooUser:
            paymentView.isUserInteractionEnabled = false
        default:
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
        switch Karhoo.configuration.authenticationMethod() {
        case .karhooUser:
            return nil
        default:
            return commentsInputText.getIntput()
        }
    }
    
    func getFlightNumber() -> String? {
        switch Karhoo.configuration.authenticationMethod() {
        case .karhooUser:
            return nil
        default:
            return poiDetailsInputText.getIntput()
        }
    }

    func paymentView(hidden: Bool) {
        switch Karhoo.configuration.authenticationMethod() {
        case .karhooUser:
            paymentView.isHidden = hidden
        default:
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
