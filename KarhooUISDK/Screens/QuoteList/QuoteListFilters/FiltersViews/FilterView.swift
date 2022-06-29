//
//  FilterView.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 21/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit

protocol FilterView: UIView {
    var category: QuoteListFilters.Category { get }
    var filter: [QuoteListFilter] { get }
    var onFilterChanged: (([QuoteListFilter], QuoteListFilters.Category) -> Void)? { get set }
    func reset()
    func configure(using filter: [QuoteListFilter])
}
