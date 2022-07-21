//
//  VehicleRulesProvider.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 21/07/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

protocol VehicleRulesProvider: AnyObject {
    func update()
    func getRule(for quote: Quote, completion: @escaping (VehicleRule?) -> Void)
}

final class KarhooVehicleRulesProvider: VehicleRulesProvider {
    
    private var rulesUpdateInProgress = false
    private let quoteService: QuoteService?
    private let store: VehicleRulesStore
    private var rules: VehicleRules? {
        store.get()
    }
    
    private var onRulesUpdated: ((VehicleRules) -> Void)?
    
    
    init(
        quoteService: QuoteService? = Karhoo.getQuoteService(),
        store: VehicleRulesStore = KarhooVehicleRulesStore()
    ) {
        self.quoteService = quoteService
        self.store = store
    }
    
    private func handle(_ result: Result<VehicleRules>) {
        guard let rules = result.successValue() else {
            return
        }
        store.save(rules)
    }
    
    func update() {
        rulesUpdateInProgress = true
        quoteService?.getVehiclesRules().execute { [weak self] result in
            self?.handle(result)
            self?.rulesUpdateInProgress = false
        }
    }
    
    func getRules(completion: @escaping (VehicleRules?) -> Void) {
        if rulesUpdateInProgress {
            onRulesUpdated = completion
        } else {
            completion(rules)
        }
    }
    
    func getRule(for quote: Quote, completion: @escaping (VehicleRule?) -> Void) {
        let quoteTags = Set(quote.vehicle.tags.map { $0.lowercased() })
        getRules { vehicleRules in
            let rule = vehicleRules?.rules.first { rule in
                let ruleTags = Set(rule.tags.map { $0.lowercased() })
                return rule.type.lowercased() == quote.vehicle.type.lowercased() && ruleTags.isSubset(of: quoteTags)
            }
            completion(rule)
        }
    }
}
