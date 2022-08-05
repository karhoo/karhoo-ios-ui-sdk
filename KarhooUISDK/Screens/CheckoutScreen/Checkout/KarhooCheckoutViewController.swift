//
//  KarhooCheckoutViewController.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//
// swiftlint:disable file_length

import UIKit
import KarhooSDK

final class KarhooCheckoutViewController: UIViewController, CheckoutView {
    
    // MARK: - Nested types

    final class Builder: CheckoutScreenBuilder {
        func buildCheckoutScreen(
            quote: Quote,
            journeyDetails: JourneyDetails,
            bookingMetadata: [String: Any]?,
            callback: @escaping ScreenResultCallback<TripInfo>
        ) -> Screen {
            
            let presenter = KarhooCheckoutPresenter(
                quote: quote,
                journeyDetails: journeyDetails,
                bookingMetadata: bookingMetadata,
                callback: callback
            )
            return KarhooCheckoutViewController(presenter: presenter)
        }
    }

    // MARK: - Properties

    private var didSetupConstraints = false
    private var containerBottomConstraint: NSLayoutConstraint!
    private let drawAnimationTime: Double = 0.45
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

    var areTermsAndConditionsAccepted: Bool { termsConditionsView.isAccepted }
    var presenter: CheckoutPresenter
    var passengerDetailsValid: Bool?
    var paymentNonce: Nonce?

    // MARK: - Child ViewControllers
  
    var legalNoticeViewController: LegalNoticeViewController
  
    // MARK: - Views

    private var termsConditionsView: TermsConditionsView!

    private var headerView: KarhooCheckoutHeaderView!

    private(set) var loyaltyView: KarhooLoyaltyView!
 
    private lazy var footerStack: UIStackView = {
        let footerStack = UIStackView()
        footerStack.translatesAutoresizingMaskIntoConstraints = false
        footerStack.accessibilityIdentifier = "footer_stack_view"
        footerStack.axis = .vertical
        footerStack.spacing = standardSpacing
        return footerStack
    }()
    
    private(set) lazy var bookingButton: KarhooBookingButtonView = {
        let bookingButton = KarhooBookingButtonView()
        bookingButton.anchor(height: UIConstants.Dimension.Button.mainActionButtonHeight)
        bookingButton.set(actions: self)
        return bookingButton
    }()
    
    private lazy var footerView: UIView = {
        let footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.accessibilityIdentifier = "footer_view"
        footerView.backgroundColor = .white
        footerView.addShadow(Float(UIConstants.Alpha.lightShadow), radius: UIConstants.Shadow.smallRadius)
        return footerView
    }()
    
    private(set) lazy var commentsInputText: KarhooTextInputView = {
        let commentsInputText = KarhooTextInputView(contentType: .comment, isOptional: true, accessibilityIdentifier: "comment_input_view")
        commentsInputText.delegate = self
        return commentsInputText
    }()
    
    private(set) lazy var poiDetailsInputText: KarhooTextInputView = {
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
    
    private(set) lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = KHPassengerDetailsViewID.backButton
        button.tintColor = KarhooUI.colors.text
        button.setImage(UIImage.uisdkImage("backIcon").withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle(UITexts.Generic.back, for: .normal)
        button.setTitleColor(KarhooUI.colors.text, for: .normal)
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
        cancellationInfo.textColor = KarhooUI.colors.text
        cancellationInfo.numberOfLines = 0
        return cancellationInfo
    }()
    
    private(set) lazy var rideInfoStackView: UIStackView = {
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
    
    private(set) lazy var farePriceInfoView: KarhooFareInfoView = {
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
        let legalNoticePresenter = KarhooLegalNoticePresenter()
        legalNoticeViewController = LegalNoticeViewController(presenter: legalNoticePresenter)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        termsConditionsView = TermsConditionsView(
            isAcceptanceRequired: presenter.shouldRequireExplicitTermsAndConditionsAcceptance()
        )
        loyaltyView = KarhooLoyaltyView()
        loyaltyView.delegate = self
        setUpView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        presenter.screenWillAppear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passengerDetailsAndPaymentView.details = initialisePassengerDetails()
        forceLightMode()
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
        addChild(legalNoticeViewController)
        baseStackView.addViewToStack(view: legalNoticeViewController.view)
        legalNoticeViewController.didMove(toParent: self)
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
        container.anchorToSuperview()

        backButton.anchor(top: container.topAnchor,
                          leading: container.leadingAnchor,
                          paddingTop: view.safeAreaInsets.top + standardSpacing,
                          paddingBottom: standardSpacing,
                          width: standardButtonSize * 2)
        
        containerBottomConstraint = container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: UIScreen.main.bounds.height)
        containerBottomConstraint.isActive = true
        baseStackView.anchor(
            top: backButton.bottomAnchor,
            leading: container.leadingAnchor,
            trailing: container.trailingAnchor,
            bottom: footerView.topAnchor
        )

        headerView.anchor(leading: baseStackView.leadingAnchor, trailing: baseStackView.trailingAnchor, paddingLeft: standardSpacing, paddingRight: standardSpacing)
        headerView.heightAnchor.constraint(greaterThanOrEqualToConstant: headerViewHeight).isActive = true
        
        cancellationInfoLabel.anchor(top: headerView.bottomAnchor,
                                     leading: baseStackView.leadingAnchor,
                                     trailing: baseStackView.trailingAnchor,
                                     paddingTop: standardPadding,
                                     paddingLeft: standardPadding,
                                     paddingRight: standardPadding,
                                     paddingBottom: standardPadding)
        
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
        
        footerView.anchor(
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            bottom: view.bottomAnchor
        )
        footerStack.anchor(
            top: footerView.topAnchor,
            leading: footerView.leadingAnchor,
            trailing: footerView.trailingAnchor,
            bottom: footerView.bottomAnchor,
            paddingTop: UIConstants.Spacing.standard,
            paddingBottom: UIConstants.Spacing.xLarge
        )
        termsConditionsView.anchor(
            leading: baseStackView.leadingAnchor,
            trailing: baseStackView.trailingAnchor
        )
        legalNoticeViewController.view.anchor(
            top: termsConditionsView.bottomAnchor,
            leading: baseStackView.leadingAnchor,
            trailing: baseStackView.trailingAnchor
        )
    }
    
    // MARK: - CheckoutView methods

    // MARK: Set state

    func setRequestingState() {
        disableUserInteraction()
        bookingButton.setRequestingMode()
    }
    
    func setMoreDetailsState() {
        bookingButton.setBookNowMode()
    }
    
    func setDefaultState() {
        enableUserInteraction()
        bookingButton.setRequestMode()
    }
    
    func resetPaymentNonce() {
        paymentNonce = nil
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
        
        loyaltyView.isHidden = !showLoyalty
        if showLoyalty {
            let loyaltyDataModel = LoyaltyViewDataModel(loyaltyId: loyaltyId ?? "",
                                                        currency: quote.price.currencyCode,
                                                        tripAmount: quote.price.highPrice)
            loyaltyView.set(dataModel: loyaltyDataModel, quoteId: quote.id)
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

    // MARK: Show

    func showTermsConditionsRequiredError() {
        termsConditionsView.showNoAcceptanceError()
        baseStackView.scrollTo(termsConditionsView, animated: true)
    }

    // MARK: Data management
    
    func getPassengerDetails() -> PassengerDetails? {
        passengerDetailsAndPaymentView.details
    }
    
    func getPaymentNonce() -> Nonce? {
        paymentNonce
    }
    
    func getComments() -> String? {
        return commentsInputText.getInput()
    }
    
    func getFlightNumber() -> String? {
        return poiDetailsInputText.getInput()
    }
    
    func getLoyaltyNonce(quoteId: String, completion: @escaping (Result<LoyaltyNonce>) -> Void) {
        return loyaltyView.getLoyaltyPreAuthNonce(quoteId: quoteId, completion: completion)
    }

    func setPassenger(details: PassengerDetails?) {
        passengerDetailsAndPaymentView.details = details
    }

    // MARK: Events

    func quoteDidExpire() {
        let alertHandler = AlertHandler(viewController: self)

        let showAlert: () -> Void = {
            alertHandler.show(
                title: UITexts.Booking.quoteExpiredTitle,
                message: UITexts.Booking.quoteExpiredMessage,
                actions: [
                    AlertAction(title: UITexts.Generic.ok, style: .default) { [weak self] _ in
                        self?.setDefaultState()
                        self?.presenter.didPressCloseOnExpirationAlert()
                    }
                ]
            )
        }

        if let presentedViewController = presentedViewController {
            presentedViewController.dismiss(animated: true) {
                showAlert()
            }
        } else {
            showAlert()
        }
    }

    // MARK: - Helpers

    private func enableUserInteraction() {
        backButton.isUserInteractionEnabled = true
        backButton.tintColor = KarhooUI.colors.text
    }
    
    private func disableUserInteraction() {
        backButton.isUserInteractionEnabled = false
        backButton.tintColor = KarhooUI.colors.medGrey
    }
    
    private func initialisePassengerDetails() -> PassengerDetails? {
        if PassengerInfo.shared.getDetails() == nil {
            return PassengerInfo.shared.currentUserAsPassenger()
        } else {
            return PassengerInfo.shared.getDetails()
        }
    }

    // MARK: - Actions
    
    @objc private func didTapView() {
        view.endEditing(true)
    }
    
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}
