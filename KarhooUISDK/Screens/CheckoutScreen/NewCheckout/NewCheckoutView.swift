//
//  NewCheckoutView.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 05/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct NewCheckoutView: View {

    var presenter: NewCheckoutPresenter

    var body: some View {
        VStack {
            addressView
            Text("new checkout")
        }
    }

    @ViewBuilder
    private var addressView: some View {
        KarhooAddressView(
            pickUp: .init(text: "", subtext: ""),
            destination: .init(text: "", subtext: ""),
            design: .default,
            showsLineBetweenPickUpAndDestination: true,
            timeLabelText: "NOW"
        )
    }
}
