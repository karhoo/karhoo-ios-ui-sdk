//
//  ViewController.swift
//  Client
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooUISDK
import CoreLocation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Do any additional setup after loading the view.
        let prefill = JourneyInfo(origin: CLLocation(latitude: 51.564159, longitude: 0.159644),
                                  destination: CLLocation(latitude: 51.564159, longitude: -0.109863),
                                  date: nil)
        let bookingScreen = KarhooUI().screens().booking().buildBookingScreen(journeyInfo: prefill,
                                                                              passengerDetails: nil,
                                                                              callback: nil)

        self.present(bookingScreen, animated: true, completion: nil)
    }
}
