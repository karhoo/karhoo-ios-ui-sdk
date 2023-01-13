//
//  SwiftUIView.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 03.11.2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct KarhooBottomSheet<Content: View>: View {
    // MARK: - Properties
    private var viewModel: BottomSheetViewModel
    @ViewBuilder private let content: () -> Content
    @ObservedObject private var keyboard = KeyboardResponder()
    @State private var offset = CGSize.zero

    // MARK: - Init
    init(viewModel: BottomSheetViewModel, @ViewBuilder content: @escaping () -> Content) {
        self.viewModel = viewModel
        self.content = content
    }
   
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0.0, content: {
            Spacer()
                .background(Color.clear)
                .layoutPriority(Double(UILayoutPriority.defaultLow.rawValue))
            
            VStack(spacing: 0.0) {
                HStack {
                    Text(viewModel.title)
                        .font(Font(KarhooUI.fonts.title2Bold()))
                        .foregroundColor(Color(KarhooUI.colors.text))
                    Spacer()
                        .background(Color.clear)
                    Button {
                        viewModel.dismiss()
                    } label: {
                        Image(
                            uiImage:
                                UIImage.uisdkImage("kh_uisdk_cross_new")
                                .coloured(withTint: KarhooUI.colors.text)
                        )
                    }
                    .frame(
                        width: UIConstants.Dimension.Button.standard,
                        height: UIConstants.Dimension.Button.standard
                    )
                    .accessibilityLabel(Text(UITexts.Generic.closeTheScreen))
                }
                .padding(
                    EdgeInsets(
                        top: UIConstants.Spacing.standard,
                        leading: UIConstants.Spacing.standard,
                        bottom: 0,
                        trailing: UIConstants.Spacing.small
                    )
                )
                
                // The content is not wrapped inside a ScrollView intentionally
                // A ScrollView expands to the full height available which is not a desired outcome for all instances where this bottom sheet will be used
                // Trying to control the height of the ScrollView with GeometryReader gives odd behaviours to the UI, so it is not recommended
                // If the content view runs the risk of going off screen either because of the amount of content or because a keyboard needs to be opened,
                // then wrap that view inside a ScrollView before injecting it into this bottom sheet
                content()
                    .padding(UIConstants.Spacing.standard)

                Spacer()
                    .frame(height: getBottomPadding())
                    .animation(.easeOut(duration: UIConstants.Duration.medium))
            }
            .background(viewModel.backgroundColor)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: viewModel.cornerRadius,
                    style: .continuous
                )
            )
            .frame(
                maxWidth: UIScreen.main.bounds.width,
                maxHeight: UIScreen.main.bounds.height - getTopPadding(),
                alignment: .bottom
            )
            .layoutPriority(Double(UILayoutPriority.defaultHigh.rawValue))
            .offset(x: 0, y: offset.height)
            .onTapGesture {
                // Do nothing. This was added to intercept touches so that they aren't picked up by the main VStack tap gesture recognizer
                // .allowsHitTesting(false) does not work for SwiftUI views presented from UIKit views
            }
        })
        .colorScheme(.light) // Delete this line after dark mode modifications
        .background(
            LinearGradient(
                colors: [
                    Color(KarhooUI.colors.black).opacity(UIConstants.Alpha.hidden),
                    Color(KarhooUI.colors.black).opacity(UIConstants.Alpha.enabled)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .edgesIgnoringSafeArea([.all])
        .opacity(2 - Double(offset.height / 100))
        .gesture(
            DragGesture()
                .onChanged({ gesture in
                    if gesture.translation.height > 0 {
                        offset = gesture.translation
                    }
                })
                .onEnded({ _ in
                    if offset.height > 100 {
                        viewModel.dismiss()
                    } else {
                        offset = .zero
                    }
                })
        )
        .onTapGesture {
            viewModel.dismiss()
        }
    }
    
    // MARK: - Helpers
    private func getBottomPadding() -> CGFloat {
        guard keyboard.currentHeight > 0 else {
            let safeArea = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
            return safeArea
        }
        
        return keyboard.currentHeight
    }
    
    private func getTopPadding() -> CGFloat {
        UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
    }
}

struct KarhooBottomSheetPreviews: PreviewProvider {
    static var previews: some View {
        KarhooBottomSheet(
            viewModel: KarhooBottomSheetViewModel(
                title: "Some title",
                onDismissCallback: {
                })) {
                    VStack {
                        Text("Inner View")
                    }
                }
    }
}

final class KarhooBottomSheetScreenBuilder: BottomSheetScreenBuilder {
    func buildBottomSheetScreenBuilderForUIKit(
        viewModel: BottomSheetViewModel,
        content: @escaping () -> some View
    ) -> Screen {
        let sheet = KarhooBottomSheet(viewModel: viewModel) {
            content()
        }
        let vc = UIHostingController(rootView: sheet)
        vc.view.backgroundColor = UIColor.clear
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
}
