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
    
    var position: FloatingPanelPosition = .bottom
    var initialState: FloatingPanelState { .half }
    var anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
        return [.full: FloatingPanelLayoutAnchor(absoluteInset: 140, edge: .top, referenceGuide: .safeArea),
                .half: FloatingPanelLayoutAnchor(absoluteInset: 230, edge: .bottom, referenceGuide: .superview),]
    }

    var supportedPositions: Set<FloatingPanelState> {
        return [.full, .half]
    }

    //TODO: backdropAlphaFor is now backdropAlpha(for: FloatingPanelState) -> CGFloat which does not work with the current switch statement
    func backdropAlpha(position: FloatingPanelState) -> CGFloat {
        switch position {
        case .full: return 0.5
        default: return 0
        }
    }
}
