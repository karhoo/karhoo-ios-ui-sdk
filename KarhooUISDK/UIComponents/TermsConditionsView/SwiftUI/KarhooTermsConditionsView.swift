//
//  KarhooTermsConditionsView.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 13/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct KarhooTermsConditionsView: View {

    @StateObject var viewModel: KarhooTermsConditionsViewModel

    var body: some View {
        HStack(alignment: .center) {
            Toggle(isOn: $viewModel.confirmed) { EmptyView() }
                .frame(width: 30, height: 30)
            TextView(text: $viewModel.text)
                .frame(width: UIScreen.main.bounds.width * 0.85)
        }
    }
}

class KarhooTermsConditionsViewModel: ObservableObject {
    var isAcceptanceRequired: Bool { true }
    @Published var text: NSAttributedString
    @Published var confirmed: Bool = false

    init() {
        self.text = NSMutableAttributedString(string: "I agree to the Terms and Conditions, the Terms of use, the Privacy Policy and the Cancellation Policy.").then {
            $0.setAttributes([.backgroundColor: UIColor.clear])
        }
    }
}
