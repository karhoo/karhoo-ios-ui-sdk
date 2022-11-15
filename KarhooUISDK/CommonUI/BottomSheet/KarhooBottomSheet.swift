//
//  SwiftUIView.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 03.11.2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct KarhooBottomSheet<Content: View>: View {
    private var viewModel: BottomSheetViewModel
    @ViewBuilder private let content: () -> Content
    @ObservedObject private var keyboard = KeyboardResponder()
    @State private var offset = CGSize.zero

    var body: some View {
        VStack(spacing: 0.0, content: {
            Spacer()
                .background(Color.clear)
                .layoutPriority(Double(UILayoutPriority.defaultLow.rawValue))
            
            VStack(spacing: 0.0) {
                HStack {
                    Text(viewModel.title)
                        .font(.headline)
                        .bold()
                        .foregroundColor(KarhooUI.colors.text.getColor())
                    Spacer()
                        .background(Color.clear)
                    Button {
                        dismiss()
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
                // If the content view runs the risk of going off screen either because of the amount of content or because a keyboard needs to be opened, then wrap that view inside a ScrollView before injecting it into this bottom sheet
                content()
                
                Spacer()
                    .frame(height: getBottomPadding())
                    .animation(.easeOut(duration: UIConstants.Duration.medium))
            }
            .background(KarhooUI.colors.white.getColor())
            .clipShape(
                RoundedRectangle(
                    cornerRadius: viewModel.cornerRadius,
                    style: .continuous
                )
            )
            .frame(
                maxHeight: UIScreen.main.bounds.height - getTopPadding(),
                alignment: .bottom
            )
            .layoutPriority(Double(UILayoutPriority.defaultHigh.rawValue))
            .onTapGesture {
                // Do nothing. This was added to intercept touches so that they aren't picked up by the main VStack tap gesture recognizer
                // .allowsHitTesting(false) does not work for SwiftUI views presented from UIKit views
            }
        })
        .colorScheme(.light) // Delete this line after dark mode modifications
        .background(
            KarhooUI.colors.black.getColor()
                .opacity(UIConstants.Alpha.overlay)
        )
        .edgesIgnoringSafeArea([.all])
        .offset(x: 0, y: offset.height)
        .opacity(2 - Double(offset.height / 200))
        .gesture(
            DragGesture()
                .onChanged({ gesture in
                    if gesture.translation.height > 0 {
                        offset = gesture.translation
                    }
                })
                .onEnded({ _ in
                    if offset.height > 100 {
                        dismiss()
                    } else {
                        offset = .zero
                    }
                })
        )
        .onTapGesture {
            dismiss()
        }
    }
    
    init(viewModel: BottomSheetViewModel, @ViewBuilder content: @escaping () -> Content) {
        self.viewModel = viewModel
        self.content = content
    }
    
    private func getBottomPadding() -> CGFloat {
        let safeArea = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        if keyboard.currentHeight > 0 {
            return keyboard.currentHeight
        }
        
        return safeArea
    }
    
    private func getTopPadding() -> CGFloat {
        UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
    }
    
    private func dismiss() {
        if let callback = viewModel.callback {
            callback(ScreenResult.cancelled(byUser: true))
        }
    }
}

struct KarhooBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        KarhooBottomSheet(viewModel: KarhooBottomSheetViewModel()) {
            KarhooBottomSheetChildView1(text: "Some text")
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

struct KarhooBottomSheetChildView1: View {

    @State var text: String

    var body: some View {
        VStack(spacing: 20, content: {
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum")

            TextField("Inner child here", text: $text)
                .border(Color.black)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        })
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
    }
}

struct KarhooBottomSheetChildView2: View {

    @State var text: String

    var body: some View {
        ScrollView {
            VStack(spacing: 20, content: {
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum")
                    
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum")
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum")

                TextField("Inner child here", text: $text)
                    .border(Color.black)
            })
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        }
       
    }
}

