//
//  KarhooRidePlanningViewModel.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 03.04.2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation

class KarhooRidePlanningViewModel: ObservableObject {
    @Published var shouldResetMap: Bool = false

    func doSomethingOnSetupMapCompleted() {
        print("doSomethingOnSetupMapCompleted")
        shouldResetMap = !shouldResetMap
//        guard self?.tripAllocationView.alpha != 1 else {
//           return
//       }
//       self?.showNoLocationPermissionsPopUp()
    }
}
