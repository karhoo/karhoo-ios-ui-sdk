//
//  SwiftUIView.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 03.11.2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct KarhooBottomSheet<Content: View>: View {
    var viewModel: BottomSheetViewModel
    @ViewBuilder let content: () -> Content
    @ObservedObject private var keyboard = KeyboardResponder()
    @State private var contentFrame: CGSize?

    var body: some View {
        VStack(spacing: 0.0, content: {
            Spacer()
                .background(Color.clear)
                .layoutPriority(250)
                .onTapGesture {
                    if let callback = viewModel.callback {
                        callback(ScreenResult.cancelled(byUser: true))
                    }
                }
            
            VStack(spacing: 0.0) {
                HStack {
                    Text(viewModel.title)
                        .font(.headline)
                        .bold()
                        // .foregroundColor(KarhooUI.colors.text.getColor())
                    Spacer()
                        .background(Color.clear)
                    Button {
                        if let callback = viewModel.callback {
                            callback(ScreenResult.cancelled(byUser: true))
                        }
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
                
                content()
                
                Spacer()
                    .frame(height: getBottomPadding())
                    .animation(.easeOut(duration: UIConstants.Duration.medium))
            }
            .background(Color.white) // TODO: add karhoo color
            .clipShape(RoundedRectangle(cornerRadius: viewModel.cornerRadius, style: .continuous))
            .layoutPriority(750)
            .allowsHitTesting(false)
        })
        .edgesIgnoringSafeArea([.bottom, .top])
        .zIndex(1)
        .transition(.move(edge: .bottom))

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
}

struct KarhooBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        KarhooBottomSheet(viewModel: KarhooBottomSheetViewModel()) {
            KarhooBottomSheetChildView(text: "Some text")
        }
    }
}

struct KarhooBottomSheetChildView: View {

    @State var text: String

    var body: some View {
        VStack {
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum")
                .fixedSize(horizontal: false, vertical: true)
                
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum")
                .fixedSize(horizontal: false, vertical: true)
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum")
//            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum")
//            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum")
            TextField("Inner child here", text: $text)
                .border(Color.black)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        }
    }
}

