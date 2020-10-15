//
//  ViewController.swift
//  Client
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooUISDK
import CoreLocation
import KarhooSDK

class ViewController: UIViewController {

    private var booking: BookingScreen?

    private lazy var guestBookingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Guest Booking Flow", for: .normal)
        button.tintColor = .blue

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var authenticatedBookingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Authenticated Booking Flow", for: .normal)
        button.tintColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        guestBookingButton.addTarget(self, action: #selector(guestBookingTapped),
                                     for: .touchUpInside)
        authenticatedBookingButton.addTarget(self, action: #selector(authenticatedBookingTapped),
                                       for: .touchUpInside)
    }

    override func loadView() {
        super.loadView()
        self.view.addSubview(guestBookingButton)
        self.view.addSubview(authenticatedBookingButton)

        guestBookingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        guestBookingButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        authenticatedBookingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        authenticatedBookingButton.topAnchor.constraint(equalTo: guestBookingButton.bottomAnchor,
                                                        constant: -100).isActive = true
    }

    @objc func guestBookingTapped(sender: UIButton) {
        Karhoo.set(configuration: KarhooGuestConfig())
        showKarhoo()
    }

    @objc func authenticatedBookingTapped(sender: UIButton) {
        Karhoo.set(configuration: KarhooConfig())
        loginAndShowKarhoo()
    }

    private func loginAndShowKarhoo() {
        let userService = Karhoo.getUserService()
        userService.logout().execute(callback: { _ in})
        
        userService.login(userLogin: Keys.userLogin).execute(callback: { result in
                                                print("login: \(result)")
                                                if result.isSuccess() {
                                                    self.showKarhoo()
                                                }
        })
    }

    func showKarhoo() {
        booking = KarhooUI().screens().booking().buildBookingScreen(journeyInfo: nil,
                                                                    passengerDetails: nil,
                                                                    callback: { [weak self] result in
                                                                        self?.logout()
                                                                        switch result {
                                                                        case .completed(let result):
                                                                            switch result {
                                                                            case .tripAllocated(let trip): self?.booking?.openTrip(trip)
                                                                            default: break
                                                                            }
                                                                        default: break
                                                                        }
                                                                    }) as? BookingScreen

        self.present(booking!,
                     animated: true,
                     completion: nil)
    }

    private func logout() {
        if Karhoo.configuration.authenticationMethod().isGuest() {
            return
        }

        Karhoo.getUserService().logout().execute(callback: { _ in})
    }
}
