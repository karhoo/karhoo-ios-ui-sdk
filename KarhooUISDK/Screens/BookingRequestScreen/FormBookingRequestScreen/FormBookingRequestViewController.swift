//
//  FormBookingRequestViewController.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

final class FormBookingRequestViewController: UIViewController, BookingRequestView, BaseViewController {

    private var didSetupConstraints = false
    private var termsConditionsView: TermsConditionsView!
    private var containerBottomConstraint: NSLayoutConstraint!
    private let drawAnimationTime: Double = 0.45
    var presenter: BookingRequestPresenter
    var passengerDetailsValid: Bool?
    var headerView: FormCheckoutHeaderView!
    
    private lazy var footerStack: UIStackView = {
        let footerStack = UIStackView()
        footerStack.translatesAutoresizingMaskIntoConstraints = false
        footerStack.accessibilityIdentifier = "footer_stack_view"
        footerStack.axis = .vertical
        footerStack.spacing = 15.0
        return footerStack
    }()
    
    lazy var bookingButton: KarhooBookingButtonView = {
        let bookingButton = KarhooBookingButtonView()
        bookingButton.anchor(height: 55.0)
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
    
    private lazy var passengerDetailsAndPaymentView: PassengerDetailsPaymentView = {
        let passengerDetailsAndPaymentView = PassengerDetailsPaymentView(baseVC: self)
        passengerDetailsAndPaymentView.accessibilityIdentifier = "passenger_details_payment_view"
        passengerDetailsAndPaymentView.translatesAutoresizingMaskIntoConstraints = false
        passengerDetailsAndPaymentView.setPaymentViewActions(actions: self)
        passengerDetailsAndPaymentView.setPassengerViewActions(actions: self)
        return passengerDetailsAndPaymentView
    }()

    private lazy var backButton: UIButton = {
        let backButton = UIButton(type: .custom)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.accessibilityIdentifier = "back_button"
        backButton.setImage(UIImage.uisdkImage("backIcon").withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = KarhooUI.colors.darkGrey
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        backButton.imageView?.contentMode = .scaleAspectFit
        return backButton
    }()
    
    private lazy var backTitleButton: UIButton = {
        let backTitleButton = UIButton()
        backTitleButton.translatesAutoresizingMaskIntoConstraints = false
        backTitleButton.accessibilityIdentifier = "back_title_button"
        backTitleButton.setTitle(UITexts.Generic.back, for: .normal)
        backTitleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12.0)
        backTitleButton.setTitleColor(KarhooUI.colors.primaryTextColor, for: .normal)
        backTitleButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return backTitleButton
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
    
    private var cancellationInfoLabel: UILabel = {
        let cancellationInfo = UILabel()
        cancellationInfo.translatesAutoresizingMaskIntoConstraints = false
        cancellationInfo.accessibilityIdentifier = KHFormCheckoutHeaderViewID.cancellationInfo
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
        rideInfoStackView.spacing = 8
        rideInfoStackView.distribution = .fill
        return rideInfoStackView
    }()
    
    private lazy var rideInfoView: RideInfoView = {
        let rideInfoView = RideInfoView()
        rideInfoView.translatesAutoresizingMaskIntoConstraints = false
        rideInfoView.accessibilityIdentifier = KHFormCheckoutHeaderViewID.rideInfoView
        rideInfoView.backgroundColor = KarhooUI.colors.infoBackgroundColor
        rideInfoView.layer.masksToBounds = true
        rideInfoView.layer.cornerRadius = 8.0
        rideInfoView.setActions(self)
        return rideInfoView
    }()
    
    lazy var farePriceInfoView: FarePriceInfoView = {
        let farePriceInfoView = FarePriceInfoView()
        farePriceInfoView.translatesAutoresizingMaskIntoConstraints = false
        farePriceInfoView.accessibilityIdentifier = "fare_price_info_view"
        farePriceInfoView.backgroundColor = KarhooUI.colors.accent
        farePriceInfoView.layer.masksToBounds = true
        farePriceInfoView.layer.cornerRadius = 8.0
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
        termsConditionsView = TermsConditionsView()
        setUpView()
    }
    
    private func setUpView() {
        container.addSubview(backButton)
        container.addSubview(backTitleButton)
        container.addSubview(baseStackView)
        
        headerView = FormCheckoutHeaderView()
        baseStackView.addViewToStack(view: headerView)
        baseStackView.addViewToStack(view: cancellationInfoLabel)
        baseStackView.addViewToStack(view: rideInfoStackView)
        rideInfoStackView.addArrangedSubview(rideInfoView)
        baseStackView.addViewToStack(view: passengerDetailsAndPaymentView)
        baseStackView.addViewToStack(view: commentsInputText)
        baseStackView.addViewToStack(view: poiDetailsInputText)
        baseStackView.addViewToStack(view: termsConditionsView)
        
        container.addSubview(footerView)
        footerView.addSubview(footerStack)
        footerStack.addArrangedSubview(bookingButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        container.addGestureRecognizer(tapGesture)
        view.setNeedsUpdateConstraints()
        
        presenter.load(view: self)
        commentsInputText.isHidden = presenter.isKarhooUser()
    }
    
    override func updateViewConstraints() {
        if didSetupConstraints == false {
            setupConstraintsForDefault()
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    // TODO: Children of stack views shouldn't be anchored to their parent.
    // Set the directionalLayoutMargins of the base stack view for insets
    // and the spacing of the base stack view for distancing the children between each other
    private func setupConstraintsForDefault() {
        view.anchor(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        container.anchor(leading: view.leadingAnchor, trailing: view.trailingAnchor, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        backButton.anchor(top: container.topAnchor, leading: container.leadingAnchor, paddingTop: view.safeAreaInsets.top, paddingLeft: 20.0)
        backTitleButton.centerY(inView: backButton)
        backTitleButton.anchor(top: backButton.topAnchor, leading: backButton.trailingAnchor, paddingRight: 10.0)
        
        containerBottomConstraint = container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: UIScreen.main.bounds.height)
        containerBottomConstraint.isActive = true
        baseStackView.anchor(top: backButton.bottomAnchor, leading: container.leadingAnchor, bottom: footerView.topAnchor, trailing: container.trailingAnchor)
        
        let titleInset: CGFloat = 15.0
        headerView.anchor(leading: baseStackView.leadingAnchor, trailing: baseStackView.trailingAnchor, paddingLeft: titleInset, paddingRight: titleInset)
        headerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 90.0).isActive = true
        
        cancellationInfoLabel.anchor(top: headerView.bottomAnchor, leading: baseStackView.leadingAnchor, trailing: baseStackView.trailingAnchor, paddingTop: 20.0, paddingLeft: 20.0, paddingBottom: 20.0, paddingRight: 20.0)
        
        rideInfoStackView.anchor(top: cancellationInfoLabel.bottomAnchor, leading: baseStackView.leadingAnchor, trailing: baseStackView.trailingAnchor, paddingTop: 8.0, paddingLeft: titleInset, paddingRight: titleInset)
        passengerDetailsAndPaymentView.anchor(top: rideInfoStackView.bottomAnchor, leading: baseStackView.leadingAnchor, trailing: baseStackView.trailingAnchor, paddingTop: titleInset, paddingLeft: titleInset, paddingRight: titleInset, height: 92.0)

        poiDetailsInputText.anchor(leading: baseStackView.leadingAnchor, trailing: baseStackView.trailingAnchor, paddingLeft: titleInset, paddingRight: titleInset)
        commentsInputText.anchor(leading: baseStackView.leadingAnchor, trailing: baseStackView.trailingAnchor, paddingLeft: titleInset, paddingRight: titleInset)
        
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
        passengerDetailsAndPaymentView.details = initialisePassengerDetails()
        forceLightMode()
    }
    
    private func initialisePassengerDetails() -> PassengerDetails? {
        if PassengerInfo.shared.passengerDetails == nil {
            return PassengerInfo.shared.currentUserAsPassenger()
        } else {
            return PassengerInfo.shared.passengerDetails
        }
    }
    
    @objc private func didTapView() {
        view.endEditing(true)
    }
    
    @objc func backButtonPressed() {
        presenter.didPressClose()
    }
    
    func setPassenger(details: PassengerDetails?) {
        passengerDetailsAndPaymentView.details = details
    }
    
    func showBookingRequestView(_ show: Bool) {
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
    
    func setAddFlightDetailsState() {
        enableUserInteraction()
        poiDetailsInputText.isHidden = false
    }
    
    func set(quote: Quote) {
        let viewModel = QuoteViewModel(quote: quote)
        passengerDetailsAndPaymentView.quote = quote
        headerView.set(viewModel: viewModel)
        rideInfoView.setDetails(viewModel: viewModel)
        termsConditionsView.setBookingTerms(supplier: quote.fleet.name, termsStringURL: quote.fleet.termsConditionsUrl)
        cancellationInfoLabel.text = viewModel.freeCancellationMessage
        farePriceInfoView.setInfoText(for: quote.quoteType)
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
        backTitleButton.isUserInteractionEnabled = true
        backButton.tintColor = KarhooUI.colors.darkGrey
        backTitleButton.tintColor = KarhooUI.colors.darkGrey
    }
    
    private func disableUserInteraction() {
        backButton.isUserInteractionEnabled = false
        backTitleButton.isUserInteractionEnabled = false
        backButton.tintColor = KarhooUI.colors.medGrey
        backTitleButton.tintColor = KarhooUI.colors.medGrey
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
}
