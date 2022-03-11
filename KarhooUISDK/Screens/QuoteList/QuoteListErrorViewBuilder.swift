//
// Created by Aleksander Wedrychowski on 10/03/2022.
// Copyright (c) 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

enum QuoteListErrorViewBuilder {

    static func buildView(for error: QuoteListState.Error) -> UIView {
        switch error {
        case .noAvailabilityInRequestedArea:
            return buildNoAvailabilityErrorView()
        default:
            return UIView()
        }
    }

    private static func buildNoAvailabilityErrorView() -> UIView {
        UIView().then { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .red
        }
    }

    private static func buildBaseErrorView() -> UIView {
        QuoteListErrorView()
    }
}

final class QuoteListErrorView: UIView {
    private lazy var titleLabel = UILabel().then {
        $0.text = "title label"
    }

    private lazy var descriptionLabel = UILabel().then {
        $0.text = "descriptionLabel"
    }
}
