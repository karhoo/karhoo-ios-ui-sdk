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
import KarhooUISDK

class ViewController: UIViewController {

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
            let booking = KarhooUI().screens().booking().buildBookingScreen(journeyInfo: nil, passengerDetails: nil, callback: { result in
                print("booking screen result: \(result)")
            })

            self.present(booking,
                         animated: true,
                         completion: nil)
        }
    }
}
