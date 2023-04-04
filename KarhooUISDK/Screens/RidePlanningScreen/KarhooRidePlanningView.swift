//
//  KarhooRidePlanningView.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 04.04.2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct KarhooRidePlanningView: View {
    
    @StateObject var viewModel: KarhooRidePlanningViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct KarhooRidePlanningView_Previews: PreviewProvider {
    static var previews: some View {
        KarhooRidePlanningView(viewModel: KarhooRidePlanningViewModel())
    }
}
