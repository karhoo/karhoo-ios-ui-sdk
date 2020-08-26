//
//  BookingRequestViewController.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

public struct KHBookingRequestViewID {
    public static let exitBackgroundButton = "exit_background_button"
    public static let exitButton = "exit_button"
}

final class KarhooBookingRequestViewController: UIViewController, BookingRequestView {

    private var didSetupConstraints = false
    
    private var exitBackgroundButton: UIView!
    private var container: UIView!
    private var containerBottomConstraint: NSLayoutConstraint!
    private var mainStackContainer: UIStackView!
    private var mainStackBottomPadding: NSLayoutConstraint!
    
    private var supplierStackContainer: UIStackView!
    private var supplierView: SupplierView!
    private var exitButton: UIButton!
    
    private var timePriceView: KarhooTimePriceView!

    private lazy var paymentView: PaymentView = {
        let view = KarhooPaymentView()
        return view
    }()

    private var termsConditionsView: TermsConditionsView!
    private var separatorLine: LineView!
    private var bookingButton: KarhooBookingButtonView!
    
    private let presenter: BookingRequestPresenter
    private let drawAnimationTime: Double = 0.45

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
    
        view.setNeedsUpdateConstraints()
        
        presenter.load(view: self)
    }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            _ = [view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
                 view.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height)].map { $0.isActive = true }
            
            _ = [exitBackgroundButton.topAnchor.constraint(equalTo: view.topAnchor),
                 exitBackgroundButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
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
                 supplierView.bottomAnchor.constraint(equalTo: supplierStackContainer.bottomAnchor)]
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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBookingRequestView(true)
    }
    
    @objc
    func closePressed() {
        presenter.didPressClose()
    }

    func showBookingRequestView(_ show: Bool) {
        if show {
            mainStackBottomPadding.constant = -20.0
            containerBottomConstraint.constant = 0.0
            if #available(iOS 11.0, *) {
                mainStackBottomPadding.constant = -view.safeAreaInsets.bottom - 20
            }
        } else {
            containerBottomConstraint.constant = UIScreen.main.bounds.height / 2
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
        bookingButton.setAddFlightDetailsMode()
    }

    func set(quote: Quote) {
        let viewModel = QuoteViewModel(quote: quote)
        supplierView.set(viewModel: viewModel)
        termsConditionsView.setBookingTerms(supplier: quote.fleet.name,
                                            termsStringURL: quote.fleet.termsConditionsUrl)
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
        paymentView.startRegisterCardFlow()
    }

    private func enableUserInteraction() {
        exitButton.isUserInteractionEnabled = true
        exitButton.tintColor = KarhooUI.colors.secondary
        exitBackgroundButton?.isUserInteractionEnabled = true
        
        paymentView.isUserInteractionEnabled = true
    }

    private func disableUserInteraction() {
        exitButton.isUserInteractionEnabled = false
        exitButton.tintColor = KarhooUI.colors.medGrey
        exitBackgroundButton?.isUserInteractionEnabled = false
    
        paymentView.isUserInteractionEnabled = false
    }

    final class KarhooBookingRequestScreenBuilder: BookingRequestScreenBuilder {

        func buildBookingRequestScreen(quote: Quote,
                                       bookingDetails: BookingDetails,
                                       callback: @escaping ScreenResultCallback<TripInfo>) -> Screen {

            let presenter = KarhooBookingRequestPresenter(quote: quote,
                                                          bookingDetails: bookingDetails,
                                                          callback: callback)

            let item = KarhooBookingRequestViewController(presenter: presenter)

            return item
        }
    }
}

extension KarhooBookingRequestViewController: TimePriceViewActions {
    func didPressFareExplanation() {
        presenter.didPressFareExplanation()
    }
}

extension KarhooBookingRequestViewController: BookingButtonActions {
    func requestPressed() {
        presenter.bookTripPressed()
    }

    func addFlightDetailsPressed() {
        presenter.didPressAddFlightDetails()
    }
}
