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

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack {
                HStack{
                    Text(viewModel.title)
                        .font(.headline)
                        .bold()
                    Spacer()
                    Button(action: {
                        if let callback = viewModel.callback {
                            callback(ScreenResult.cancelled(byUser: true))
                        }
                    }) {
                        Image(uiImage: UIImage.uisdkImage("kh_uisdk_cross"))
                    }
                    .frame(
                        width: UIConstants.Dimension.Button.standard,
                        height: UIConstants.Dimension.Button.standard
                    )
                }
                .padding(
                    EdgeInsets(
                        top: UIConstants.Spacing.standard,
                        leading: UIConstants.Spacing.marginToEdgeOfScreen,
                        bottom: 0,
                        trailing: UIConstants.Spacing.marginToEdgeOfScreen
                    )
                )
                
                content()
                
                Spacer()
                    .frame(maxHeight:UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: viewModel.cornerRadius, style: .continuous))
            
            
        }
        .zIndex(1)
        .transition(.move(edge: .bottom))
        .edgesIgnoringSafeArea(.all)
    }
    
    init(viewModel: BottomSheetViewModel, @ViewBuilder content: @escaping () -> Content) {
        self.viewModel = viewModel
        self.content = content
    }
}

//struct KarhooBottomSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        KarhooBottomSheet(viewModel: KarhooBottomSheetViewModel()) {
//            KarhooBottomSheetChildView(text: "Some text")
//        }
//    }
//}

struct KarhooBottomSheetChildView: View {

    @State var text: String
    var body: some View {
        VStack {
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum")
            
            TextField("Inner child here", text: $text)
        }
    }
}
