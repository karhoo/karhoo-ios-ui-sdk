//
//  KarhooCheckoutViewController.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

final class KarhooCheckoutViewController: UIViewController, CheckoutView {
    
    // MARK: - Nested types

    final class Builder: CheckoutScreenBuilder {
        func buildCheckoutScreen(
            quote: Quote,
            bookingDetails: BookingDetails,
            bookingMetadata: [String: Any]?,
            callback: @escaping ScreenResultCallback<TripInfo>
        ) -> Screen {
            
            let presenter = KarhooCheckoutPresenter(
                quote: quote,
                bookingDetails: bookingDetails,
                bookingMetadata: bookingMetadata,
                callback: callback
            )
            return KarhooCheckoutViewController(presenter: presenter)
        }
    }

    // MARK: - Properties

    private var didSetupConstraints = false
    private var termsConditionsView: TermsConditionsView!
    private var containerBottomConstraint: NSLayoutConstraint!
    private let drawAnimationTime: Double = 0.45
    var presenter: CheckoutPresenter
    var passengerDetailsValid: Bool?
    var paymentNonce: String?

    private let smallSpacing: CGFloat = 8.0
    private let standardSpacing: CGFloat = 16.0
    private let smallPadding: CGFloat = 10.0
    private let standardPadding: CGFloat = 20.0
    private let standardButtonSize: CGFloat = 44.0
    private let mainButtonHeight: CGFloat = 55.0
    private let largeCornerRadius: CGFloat = 10.0
    private let mediumCornerRadius: CGFloat = 8.0
    private let headerViewHeight: CGFloat = 90.0
    private let passengerDetailsAndPaymentViewHeight: CGFloat = 90.0
    private var mainStackBottomPadding: NSLayoutConstraint!
    
    
    
    // MARK: - Views

    var headerView: KarhooCheckoutHeaderView!

    var loyaltyView: KarhooLoyaltyView!

    private lazy var footerStack: UIStackView = {
        let footerStack = UIStackView()
        footerStack.translatesAutoresizingMaskIntoConstraints = false
        footerStack.accessibilityIdentifier = "footer_stack_view"
        footerStack.axis = .vertical
        footerStack.spacing = standardSpacing
        return footerStack
    }()
    
    lazy var bookingButton: KarhooBookingButtonView = {
        let bookingButton = KarhooBookingButtonView()
        bookingButton.anchor(height: mainButtonHeight)
        bookingButton.set(actions: self)
        return bookingButton
    }()
    
    private lazy var footerView: UIView = {
        let footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.accessibilityIdentifier = "footer_view"
        footerView.backgroundColor = .white
        return footerView
    }()
    
    lazy var commentsInputText: KarhooTextInputView = {
        let commentsInputText = KarhooTextInputView(contentType: .comment, isOptional: true, accessibilityIdentifier: "comment_input_view")
        commentsInputText.delegate = self
        return commentsInputText
    }()
    
    private lazy var poiDetailsInputText: KarhooTextInputView = {
        let poiDetailsInputText = KarhooTextInputView(contentType: .poiDetails, isOptional: true, accessibilityIdentifier: "poi_input_view")
        poiDetailsInputText.delegate = self
        poiDetailsInputText.isHidden = true
        return poiDetailsInputText
    }()
    
    private lazy var passengerDetailsAndPaymentView: KarhooAddPassengerDetailsAndPaymentView = {
        let passengerDetailsAndPaymentView = KarhooAddPassengerDetailsAndPaymentView(baseVC: self)
        passengerDetailsAndPaymentView.accessibilityIdentifier = "passenger_details_payment_view"
        passengerDetailsAndPaymentView.translatesAutoresizingMaskIntoConstraints = false
        passengerDetailsAndPaymentView.setPaymentViewActions(actions: self)
        passengerDetailsAndPaymentView.setPassengerViewActions(actions: self)
        return passengerDetailsAndPaymentView
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = KHPassengerDetailsViewID.backButton
        button.tintColor = KarhooUI.colors.darkGrey
        button.setImage(UIImage.uisdkImage("backIcon").withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle(UITexts.Generic.back, for: .normal)
        button.setTitleColor(KarhooUI.colors.darkGrey, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12.0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: smallSpacing, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var container: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.accessibilityIdentifier = "container_view"
        container.layer.cornerRadius = largeCornerRadius
        container.layer.masksToBounds = true
        container.backgroundColor = .white
        return container
    }()
    
    private lazy var baseStackView: BaseStackView = {
       let baseStackView = BaseStackView()
        baseStackView.translatesAutoresizingMaskIntoConstraints = false
        baseStackView.accessibilityIdentifier = "base_stack_view"
        baseStackView.viewSpacing(standardSpacing)
        return baseStackView
    }()
    
    private var cancellationInfoLabel: UILabel = {
        let cancellationInfo = UILabel()
        cancellationInfo.translatesAutoresizingMaskIntoConstraints = false
        cancellationInfo.accessibilityIdentifier = KHCheckoutHeaderViewID.cancellationInfo
        cancellationInfo.font = KarhooUI.fonts.captionRegular()
        cancellationInfo.textColor = KarhooUI.colors.primaryTextColor
        cancellationInfo.text = "Free cancellation until arrival of the driver"
        cancellationInfo.numberOfLines = 0
        return cancellationInfo
    }()
    
    lazy var rideInfoStackView: UIStackView = {
        let rideInfoStackView = UIStackView()
        rideInfoStackView.accessibilityIdentifier = "ride_info_stack_view"
        rideInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        rideInfoStackView.axis = .vertical
        rideInfoStackView.spacing = smallSpacing
        rideInfoStackView.distribution = .fill
        return rideInfoStackView
    }()
    
    private lazy var rideInfoView: KarhooRideInfoView = {
        let rideInfoView = KarhooRideInfoView()
        rideInfoView.translatesAutoresizingMaskIntoConstraints = false
        rideInfoView.accessibilityIdentifier = KHCheckoutHeaderViewID.rideInfoView
        rideInfoView.backgroundColor = KarhooUI.colors.infoBackgroundColor
        rideInfoView.layer.masksToBounds = true
        rideInfoView.layer.cornerRadius = mediumCornerRadius
        rideInfoView.setActions(self)
        return rideInfoView
    }()
    
    lazy var farePriceInfoView: KarhooFareInfoView = {
        let farePriceInfoView = KarhooFareInfoView()
        farePriceInfoView.translatesAutoresizingMaskIntoConstraints = false
        farePriceInfoView.accessibilityIdentifier = "fare_price_info_view"
        farePriceInfoView.backgroundColor = KarhooUI.colors.primary
        farePriceInfoView.layer.masksToBounds = true
        farePriceInfoView.layer.cornerRadius = mediumCornerRadius
        return farePriceInfoView
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

    // MARK: - Lifecycle

    init(presenter: CheckoutPresenter) {
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
        termsConditionsView = TermsConditionsView()
        loyaltyView = KarhooLoyaltyView()
        loyaltyView.set(delegate: self)
        setUpView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passengerDetailsAndPaymentView.details = initialisePassengerDetails()
        forceLightMode()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showCheckoutView(true)
    }
    
    override func updateViewConstraints() {
            if didSetupConstraints == false {
                setupConstraintsForDefault()
                didSetupConstraints = true
            }
            super.updateViewConstraints()
        }
    
    // MARK: - Setup

    private func setUpView() {
        container.addSubview(backButton)
        container.addSubview(baseStackView)
        
        headerView = KarhooCheckoutHeaderView()
        baseStackView.addViewToStack(view: headerView)
        baseStackView.addViewToStack(view: cancellationInfoLabel)
        baseStackView.addViewToStack(view: rideInfoStackView)
        rideInfoStackView.addArrangedSubview(rideInfoView)
        baseStackView.addViewToStack(view: loyaltyView)
        baseStackView.addViewToStack(view: passengerDetailsAndPaymentView)
        baseStackView.addViewToStack(view: poiDetailsInputText)
        baseStackView.addViewToStack(view: commentsInputText)
        baseStackView.addViewToStack(view: termsConditionsView)
        
        container.addSubview(footerView)
        footerView.addSubview(footerStack)
        footerStack.addArrangedSubview(bookingButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        container.addGestureRecognizer(tapGesture)
        view.setNeedsUpdateConstraints()
        
        presenter.load(view: self)
    }

    // TODO: Children of stack views shouldn't be anchored to their parent.
    // Set the directionalLayoutMargins of the base stack view for insets
    // and the spacing of the base stack view for distancing the children between each other
    private func setupConstraintsForDefault() {
        view.anchor(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        container.anchor(leading: view.leadingAnchor, trailing: view.trailingAnchor, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        backButton.anchor(top: container.topAnchor,
                          leading: container.leadingAnchor,
                          paddingTop: view.safeAreaInsets.top + standardSpacing,
                          paddingBottom: standardSpacing,
                          width: standardButtonSize * 2)
        
        containerBottomConstraint = container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: UIScreen.main.bounds.height)
        containerBottomConstraint.isActive = true
        baseStackView.anchor(top: backButton.bottomAnchor, leading: container.leadingAnchor, bottom: footerView.topAnchor, trailing: container.trailingAnchor)

        headerView.anchor(leading: baseStackView.leadingAnchor, trailing: baseStackView.trailingAnchor, paddingLeft: standardSpacing, paddingRight: standardSpacing)
        headerView.heightAnchor.constraint(greaterThanOrEqualToConstant: headerViewHeight).isActive = true
        
        cancellationInfoLabel.anchor(top: headerView.bottomAnchor,
                                     leading: baseStackView.leadingAnchor,
                                     trailing: baseStackView.trailingAnchor,
                                     paddingTop: standardPadding,
                                     paddingLeft: standardPadding,
                                     paddingBottom: standardPadding,
                                     paddingRight: standardPadding)
        
        rideInfoStackView.anchor(top: cancellationInfoLabel.bottomAnchor,
                                 leading: baseStackView.leadingAnchor,
                                 trailing: baseStackView.trailingAnchor,
                                 paddingTop: smallSpacing,
                                 paddingLeft: standardSpacing,
                                 paddingRight: standardSpacing)
        loyaltyView.anchor(top: rideInfoStackView.bottomAnchor, leading: rideInfoStackView.leadingAnchor, trailing: rideInfoStackView.trailingAnchor, paddingTop: standardPadding)
        
        passengerDetailsAndPaymentView.anchor(top: loyaltyView.bottomAnchor,
                                              leading: baseStackView.leadingAnchor,
                                              trailing: baseStackView.trailingAnchor,
                                              paddingTop: standardSpacing,
                                              paddingLeft: standardSpacing,
                                              paddingRight: standardSpacing,
                                              height: passengerDetailsAndPaymentViewHeight)

        poiDetailsInputText.anchor(leading: baseStackView.leadingAnchor, trailing: baseStackView.trailingAnchor, paddingLeft: standardSpacing, paddingRight: standardSpacing)
        commentsInputText.anchor(leading: baseStackView.leadingAnchor, trailing: baseStackView.trailingAnchor, paddingLeft: standardSpacing, paddingRight: standardSpacing)
        
        footerView.anchor(leading: view.leadingAnchor, bottom: container.bottomAnchor, trailing: view.trailingAnchor, paddingBottom: standardPadding, paddingRight: smallPadding)
        footerStack.anchor(top: footerView.topAnchor, leading: footerView.leadingAnchor, bottom: footerView.bottomAnchor, trailing: footerView.trailingAnchor)
        termsConditionsView.anchor(leading: baseStackView.leadingAnchor, trailing: baseStackView.trailingAnchor)
    }
    
    private func initialisePassengerDetails() -> PassengerDetails? {
        if PassengerInfo.shared.getDetails() == nil {
            return PassengerInfo.shared.currentUserAsPassenger()
        } else {
            return PassengerInfo.shared.getDetails()
        }
    }

    // MARK: - CheckoutView methods

    func showCheckoutView(_ show: Bool) {
        containerBottomConstraint.constant = show ? 0.0 : UIScreen.main.bounds.height
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

    func setPassenger(details: PassengerDetails?) {
        passengerDetailsAndPaymentView.details = details
    }

    
    func setRequestingState() {
        disableUserInteraction()
        bookingButton.setRequestingMode()
    }
    
    func setMoreDetailsState() {
        bookingButton.setNextMode()
    }
    
    func setDefaultState() {
        enableUserInteraction()
        bookingButton.setRequestMode()
    }
    
    func resetPaymentNonce() {
        self.paymentNonce = nil
        passengerDetailsAndPaymentView.noPaymentMethod()
    }
    
    func setAddFlightDetailsState() {
        enableUserInteraction()
        poiDetailsInputText.isHidden = false
    }
    
    func set(quote: Quote, showLoyalty: Bool, loyaltyId: String?) {
        let viewModel = QuoteViewModel(quote: quote)
        passengerDetailsAndPaymentView.quote = quote
        headerView.set(viewModel: viewModel)
        rideInfoView.setDetails(viewModel: viewModel)
        termsConditionsView.setBookingTerms(supplier: quote.fleet.name, termsStringURL: quote.fleet.termsConditionsUrl)
        cancellationInfoLabel.text = viewModel.freeCancellationMessage
        farePriceInfoView.setInfoText(for: quote.quoteType)
        
        self.loyaltyView.isHidden = !showLoyalty
        if showLoyalty {
            // TODO: confirm that the highPrice should be used here
            let loyaltyDataModel = LoyaltyViewDataModel(loyaltyId: loyaltyId ?? "",
                                                    currency: quote.price.currencyCode,
                                                    tripAmount: quote.price.highPrice)
            self.loyaltyView.set(dataModel: loyaltyDataModel)
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
    
    func retryAddPaymentMethod(showRetryAlert: Bool = false) {
        passengerDetailsAndPaymentView.startRegisterCardFlow(showRetryAlert: showRetryAlert)
    }
    
    private func enableUserInteraction() {
        backButton.isUserInteractionEnabled = true
        backButton.tintColor = KarhooUI.colors.darkGrey
    }
    
    private func disableUserInteraction() {
        backButton.isUserInteractionEnabled = false
        backButton.tintColor = KarhooUI.colors.medGrey
    }
    
    func getPassengerDetails() -> PassengerDetails? {
        return passengerDetailsAndPaymentView.details
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
    
    func getLoyaltyNonce(completion: @escaping (Result<LoyaltyNonce>) -> Void) {
        return loyaltyView.getLoyaltyPreAuthNonce(completion: completion)
    }

    func quoteDidExpire() {
        let expiredAlertController = UIAlertController(
            title: UITexts.Booking.quoteExpiredTitle,
            message: UITexts.Booking.quoteExpiredMessage,
            preferredStyle: .alert
        )
        expiredAlertController.addAction(
            UIAlertAction(
                title: UITexts.Generic.ok,
                style: .default
            ) { [weak self] _ in
                self?.presenter.didPressClose()
            }
        )

        if let presentedViewController = presentedViewController {
            presentedViewController.dismiss(animated: true) { [weak self] in
                self?.showAsOverlay(item: expiredAlertController, animated: true)
            }
        } else {
            showAsOverlay(item: expiredAlertController, animated: true)
        }
    }

    // MARK: - Actions
    
    @objc private func didTapView() {
        view.endEditing(true)
    }
    
    @objc func backButtonPressed() {
        presenter.didPressClose()
    }
}
