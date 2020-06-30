//
//  ViewController.swift
//  Client
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooUISDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let addressBar = KarhooUI.components.addressBar(journeyInfo: nil)

        view.backgroundColor = .white

        addressBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addressBar)

        NSLayoutConstraint.activate([
            addressBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            addressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            addressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            addressBar.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
}
