//
//  RateButtonViewModel.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

struct RateButtonViewModel {
    let buttonStates: (normal: UIImage, selected: UIImage)
    
    public init(normalImageName: String = "star_normal",
                selectedImageName: String = "star_selected") {
        self.buttonStates = (normal: UIImage.uisdkImage(normalImageName),
                             selected: UIImage.uisdkImage(selectedImageName))
    }
}
