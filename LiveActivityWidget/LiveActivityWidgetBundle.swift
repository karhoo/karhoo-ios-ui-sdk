//
//  LiveActivityWidgetBundle.swift
//  LiveActivityWidget
//
//  Created by Bartlomiej Sopala on 06/10/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct LiveActivityWidgetBundle: WidgetBundle {
    var body: some Widget {
        LiveActivityWidget()
        LiveActivityWidgetLiveActivity()
    }
}
