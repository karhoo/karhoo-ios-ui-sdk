//
//  KarhooLegalNoticeView.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 13/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct KarhooLegalNoticeView: View {

    @StateObject var viewModel: KarhooLegalNoticeViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("_hide")
                // Chevon button
                Button(
                    action: {

                    },
                    label: {
                        Image(systemName: "chevron.right")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.black)
                    }
                )
            }
            Text("Legal Notice")
                .font(.headline)
                .foregroundColor(.black)
            Text("Legal Notice")
                .font(.body)
                .foregroundColor(.black)
                .lineLimit(3)
                .padding(.top, 8)
        }
    }
}

// ViewModel
class KarhooLegalNoticeViewModel: ObservableObject {
    @Published var text: NSAttributedString
    @Published var expanded: Bool = false

    init() {
        self.text = .init(string: "The data collected are subject to processing by Accor SA for the purpose of managing your booking, getting to know you better, improving the services we provide and the customer experience. These data are sent to Accor SA, restaurants and Accor SA subcontractors. Your data may be transferred outside the European Union when this is necessary for the fulfilment or preparation of your reservation, or when appropriate and adapted guarantees have been established. You have the right to request access to your data, their rectification or erasure, to object to their processing, and to define directives concerning the processing of your data after your death by writing to the following address: all-mobility.data.privacy@accor.com. For more information on the processing of your personal data, please see our personal data protection charter.")
    }
}
