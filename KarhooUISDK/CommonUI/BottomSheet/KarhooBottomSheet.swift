//
//  SwiftUIView.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 03.11.2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct KarhooBottomSheet: View {
    @State var viewModel: BottomSheetViewModel

    var body: some View {
        VStack(spacing: 0) {
            HStack{
                Text(viewModel.title)
                    .font(.headline)
                    .bold()
                Spacer()
                Button("X") {
                    viewModel.dismiss()
                    if let callback = viewModel.callback {
                        callback(ScreenResult.cancelled(byUser: true))
                    }
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
            
            
            if let childView = viewModel.child {
                childView
            }
        }
        .cornerRadius(viewModel.cornerRadius)
        .zIndex(1)
        .transition(.move(edge: .bottom))
        .frame(height: 300, alignment: .bottom)
        .frame(alignment: .bottom)
        .background(Color.green)
    }
}

struct KarhooBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        KarhooBottomSheet(viewModel: KarhooBottomSheetViewModel())
    }
}

//struct KarhooBottomSheetChildView: View {
//
//    var body: some View {
//        ZStack {
//            Text("Inner child here")
//        }
//    }
//}
