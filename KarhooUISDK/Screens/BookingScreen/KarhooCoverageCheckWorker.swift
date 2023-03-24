//
//  KarhooCoverageCheckService.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 22/03/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

protocol CoverageCheckWorker: AnyObject {
    func getCoverage(
        for details: JourneyDetails?,
        completion: @escaping (Bool?) -> Void
    )
}

final class KarhooCoverageCheckWorker: CoverageCheckWorker {

    private let quoteService: QuoteService

    private var coverageCache: [String: Result<QuoteCoverage>] = [:]
    private var coverageCheckInProgress: [String] = []

    init(quoteService: QuoteService = Karhoo.getQuoteService()) {
        self.quoteService = quoteService
    }

    func getCoverage(
        for details: JourneyDetails?,
        completion: @escaping (Bool?) -> Void
    ) {
        guard
            let origin = details?.originLocationDetails,
            let destination = details?.destinationLocationDetails
        else {
            completion(nil)
            return
        }
        getCoverage(
            for: origin.position.latitude.description,
            and: origin.position.longitude.description,
            completion: { [weak self] result in
                guard let self else {
                    completion(true)
                    return
                }
                switch result.getSuccessValue()?.coverage {
                case true:
                    completion(Bool.random())
//                    completion(true)
                case false:
                    // Additional, optional check for destination coordinates coverage
                    self.getCoverage(
                        for: destination.position.latitude.description,
                        and: destination.position.longitude.description,
                        completion: { _ in
                            completion(Bool.random())
//                            completion($0.getSuccessValue()?.coverage ?? true)
                        }
                    )
                default:
                    // Coverage check error. `true` used just to avoid not needed flow blocking
                    completion(Bool.random())
                }
            }
        )
    }

    private func getCoverage(
        for latitude: String,
        and longitude: String,
        completion: @escaping (Result<QuoteCoverage>) -> Void
    ) {
        guard let cacheKey = getCacheKey(for: latitude, and: longitude) else {
            assertionFailure()
            completion(.success(result: .init(coverage: true)))
            return
        }

        if let cachedResult = coverageCache[cacheKey] {
            // Coordiantes already checked - stored result passed as a completion
            completion(cachedResult)
            return
        }
        guard !coverageCheckInProgress.contains(where: { $0 == cacheKey }) else {
            // Coordinates check in progress. Waiting for a BE response.
            return
        }

        coverageCheckInProgress.append(cacheKey)
        let coverageRequest = QuoteCoverageRequest(
            latitude: latitude,
            longitude: longitude
        )
        quoteService.coverage(coverageRequest: coverageRequest).execute { [weak self] result in
            self?.coverageCheckInProgress.removeAll(where: { $0 == cacheKey })
            if result.getSuccessValue() != nil {
                self?.coverageCache[cacheKey] = result
            }
            completion(result)
        }
    }

    private func getCacheKey(
        for latitude: String,
        and longitude: String
    ) -> String? {
        guard
            let doubleLatitude = Double(latitude.replacingOccurrences(of: ",", with: ".")),
            let doubleLongitude = Double(longitude.replacingOccurrences(of: ",", with: "."))
        else {
            return ""
        }
        return "\(String(format: "%.4f", doubleLatitude)), \(String(format: "%.4f", doubleLongitude))"
    }
}
