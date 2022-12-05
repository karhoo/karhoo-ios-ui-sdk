//
//  AddToCalendarViewModel.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 25/11/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import SwiftUI

extension KarhooAddToCalendarView {
    class ViewModel: ObservableObject {

        @Published var state: State = .add
        var onAddAction: (ViewModel) -> Void

        init(
            state: KarhooAddToCalendarView.State = .add,
            onAddAction: @escaping (ViewModel) -> Void
        ) {
            self.state = state
            self.onAddAction = onAddAction
        }

        func addTapped() {
            onAddAction(self)
        }
    }
}
