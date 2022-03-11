//
// Created by Aleksander Wedrychowski on 10/03/2022.
// Copyright (c) 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

enum QuoteListErrorViewBuilder {

    static func buildView(for error: QuoteListState.Error) -> UIView {
        switch error {
        case .noAvailabilityInRequestedArea:
            return buildBaseErrorView(error: error)
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

    private static func buildBaseErrorView(error: QuoteListState.Error) -> UIView {
        QuoteListErrorView(errorToPresent: error)
    }
}

final class QuoteListErrorView: UIView {
    private lazy var titleLabel = UILabel().then {
        $0.text = "title label"
        $0.textAlignment = .center
    }

    private lazy var descriptionLabel = UILabel().then {
        $0.text = "descriptionLabel"
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    private lazy var imageView = UIImageView().then {
        $0.image = imageForPresentedError
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .blue
    }

    private lazy var contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
    }

    private let presentedError: QuoteListState.Error

    init(errorToPresent: QuoteListState.Error) {
        self.presentedError = errorToPresent
        super.init(frame: .zero)
        self.setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupView() {
        addSubview(contentStackView)
        contentStackView.anchorToSuperview()
        contentStackView.addArrangedSubviews([
            buildSeparator(),
            imageView,
            buildSeparator(height: 40),
            titleLabel,
            buildSeparator(height: 10),
            descriptionLabel,
            buildSeparator()
        ])
        imageView.anchor(width: 80, height: 80)
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    private func buildSeparator(height: CGFloat? = nil) -> UIView {
        UIView().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.anchor(height: height)
        }
    }

    var imageForPresentedError: UIImage {
        switch presentedError {
        case .noAvailabilityInRequestedArea: return .uisdkImage("quoteList_error_no_availability")
        case .destinationOrOriginEmpty:
            return .uisdkImage("quoteList_error_no_availability")
        case .noResults:
            return .uisdkImage("quoteList_error_no_availability")
        case .originAndDestinationAreTheSame:
            return .uisdkImage("quoteList_error_no_availability")
        case .KarhooErrorQ0001:
            return .uisdkImage("quoteList_error_no_availability")
        case .noQuotesInSelectedCategory:
            return .uisdkImage("quoteList_error_no_availability")
        case .noQuotesForSelectedParameters:
            return .uisdkImage("quoteList_error_no_availability")
        }
    }
}

extension UIStackView {

    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach {
            addArrangedSubview($0)
        }
    }
}
