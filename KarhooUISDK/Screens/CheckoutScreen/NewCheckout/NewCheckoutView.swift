//
//  NewCheckoutView.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 05/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct NewCheckoutView<Presenter>: View where Presenter: NewCheckoutPresenter {

    @StateObject var presenter: Presenter

    var body: some View {
        Text("new checkout")
    }
}
