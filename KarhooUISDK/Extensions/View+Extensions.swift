//
//  View+Extensions.swift
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
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }

    func placeholder(
        _ text: String,
        when shouldShow: Bool,
        alignment: Alignment = .leading) -> some View {
            placeholder(when: shouldShow, alignment: alignment) { Text(text).foregroundColor(Color(KarhooUI.colors.textLabel))
        }
    }
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
