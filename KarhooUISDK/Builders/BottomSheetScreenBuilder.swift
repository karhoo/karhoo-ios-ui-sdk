//
//  BottomSheetScreenBuilder.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 14.11.2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import SwiftUI

protocol BottomSheetScreenBuilder {
    func buildBottomSheetScreenBuilderForUIKit(
        viewModel: BottomSheetViewModel,
        content: @escaping () -> some View
    ) -> Screen
}
