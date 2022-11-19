//
//  View+addBorder.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 18/11/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

extension View {
    func addBorder<S>(
        _ content: S,
        width: CGFloat = 1,
        cornerRadius: CGFloat
    ) -> some View where S: ShapeStyle {
        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
             .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }
}
