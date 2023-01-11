//
//  QuoteValidityWorker.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 06/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK
import Foundation

protocol QuoteValidityWorker {
    func setQuoteValidityDeadline(
        _ quote: Quote,
        deadlineCompletion: @escaping () -> Void
    )
}
// QuoteValidityWorker
final class KarhooQuoteValidityWorker: QuoteValidityWorker {
    private var quoteValidityTimer: Timer?
    private var deadlineCompletion: (() -> Void)?

    deinit {
        quoteValidityTimer?.invalidate()
    }

    func setQuoteValidityDeadline(
        _ quote: Quote,
        deadlineCompletion: @escaping () -> Void
    ) {
        guard let validityDate = quote.quoteExpirationDate else {
            return
        }
        let timer = Timer.scheduledTimer(
            withTimeInterval: validityDate.timeIntervalSinceNow,
            repeats: false
        ) { [weak self] _ in
            self?.deadlineCompletion?()
            self?.quoteValidityTimer?.invalidate()
            self?.quoteValidityTimer = nil
        }

        RunLoop.main.add(timer, forMode: .common)
        quoteValidityTimer = timer
    }
}
