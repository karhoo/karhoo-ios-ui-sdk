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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("booking screen result: \("result")")

        loginAndShowKarhoo()
    }

    private func loginAndShowKarhoo() {
        let userService = Karhoo.getUserService()
        userService.logout().execute(callback: { _ in})
        
        userService.login(userLogin: UserLogin(username: Keys.userServiceEmailAdyen,
                                               password: Keys.userServicePasswordAdyen)).execute(callback: { result in
                                                print("login: \(result)")
                                                if result.isSuccess() {
                                                    showKarhoo()
                                                }
                                               })

        func showKarhoo() {
             booking = KarhooUI().screens().booking().buildBookingScreen(journeyInfo: nil,
                                                                         passengerDetails: nil,
                                                                         callback: { [weak self] result in
                print("booking screen result: \(result)")
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
    }
}
