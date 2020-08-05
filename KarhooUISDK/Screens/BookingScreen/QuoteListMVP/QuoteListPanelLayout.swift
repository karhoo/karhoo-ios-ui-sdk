//
//  QuoteListPanelLayout.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import FloatingPanel

final class QuoteListPanelLayout: FloatingPanelLayout {

    static let compactSize: CGFloat = 230
    private static let topOffset: CGFloat = 140

    var initialPosition: FloatingPanelPosition {
        return .half
    }

    var supportedPositions: Set<FloatingPanelPosition> {
        return [.full, .half]
    }

    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return QuoteListPanelLayout.topOffset
        case .half: return QuoteListPanelLayout.compactSize
        default: return nil
        }
    }

    func backdropAlphaFor(position: FloatingPanelPosition) -> CGFloat {
        switch position {
        case .full: return 0.5
        default: return 0
        }
    }
}
