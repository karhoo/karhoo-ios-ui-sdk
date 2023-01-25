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
        ZStack {
            gradientBackground
            VStack(spacing: 0) {
                Spacer()
                VStack(spacing: 0) {
                    HStack {
                        Text(viewModel.title)
                            .font(Font(KarhooUI.fonts.title2Bold()))
                            .foregroundColor(Color(KarhooUI.colors.text))
                        Spacer()
                            .background(Color.clear)
                        Button(
                            action: {
                                viewModel.dismiss()
                            },
                            label: {
                                Image(
                                    uiImage:
                                        UIImage.uisdkImage("kh_uisdk_cross_new")
                                        .coloured(withTint: KarhooUI.colors.text)
                                )
                                .resizable()
                                .frame(
                                    width: UIConstants.Dimension.Icon.standard,
                                    height: UIConstants.Dimension.Icon.standard
                                )
                            }
                        )
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
                    content()
                        .padding(UIConstants.Spacing.standard)
                }
                // first backround with rounded corners
                .background(viewModel.backgroundColor.ignoresSafeArea())
                .cornerRadius(viewModel.cornerRadius, corners: [.topLeft, .topRight])
                // second background created to fill bottom safe area
                .padding(.top, -viewModel.cornerRadius)
                .background(viewModel.backgroundColor.ignoresSafeArea())
                .offset(x: 0, y: offset.height)
                .onTapGesture {
                    // Do nothing. This was added to intercept touches so that they aren't picked up by the main VStack tap gesture recognizer
                    // .allowsHitTesting(false) does not work for SwiftUI views presented from UIKit views
                }
            }
            .frame(
                maxHeight: UIScreen.main.bounds.height - getTopPadding()
            )
        }
        .colorScheme(.light) // Delete this line after dark mode modifications

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
    
    @ViewBuilder
    private var gradientBackground: some View {
        Spacer()
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

struct BottomSheetWithTextField_Previews: PreviewProvider {
    static var previews: some View {
        KarhooBottomSheet(viewModel: KarhooBottomSheetViewModel(
            title: "Flight number") { }) {
                KarhooBottomSheetContentWithTextFieldView(viewModel: .init(
                    contentType: .flightNumber,
                    initialValueForTextField: "",
                    viewSubtitle: UITexts.Booking.flightSubtitle,
                    textFieldHint: UITexts.Booking.flightExample,
                    errorMessage: UITexts.Booking.onlyLettersAndDigitsAllowedError,
                    onSaveCallback: { _ in
                        return
                    }
                )
            )
        }
    }
}
