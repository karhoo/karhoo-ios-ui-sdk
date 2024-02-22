//
//  DetailsCellViewModel.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 14/11/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import SwiftUI

class DetailsCellViewModel: ObservableObject {
    
    @Published var title: String
    @Published var subtitle: String
    @Published var iconName: String
    @Published var accessibilityTitle: String
    @Published var accessibilityIconName: String
    var onTap: () -> Void

    init() {
        self.title = ""
        self.subtitle = ""
        self.iconName = ""
        self.accessibilityTitle = ""
        self.accessibilityIconName = ""
        self.onTap = {}
    }

    init(
        title: String,
        subtitle: String,
        iconName: String,
        accessibilityTitle: String,
        accessibilityIconName: String,
        onTap: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.iconName = iconName
        self.accessibilityTitle = accessibilityTitle
        self.accessibilityIconName = accessibilityIconName
        self.onTap = onTap
    }
    
    func update(title: String, subtitle: String, accessibilityTitle: String) {
        self.title = title
        self.subtitle = subtitle
        self.accessibilityTitle = accessibilityTitle
    }
}
