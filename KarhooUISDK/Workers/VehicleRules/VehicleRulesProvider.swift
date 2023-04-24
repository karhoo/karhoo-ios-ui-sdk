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
    func getRule(
        for quote: Quote,
        completion: @escaping (VehicleImageRule?) -> Void
    )
}

final class KarhooVehicleRulesProvider: VehicleRulesProvider {
    
    private var rulesUpdateInProgress = false
    private let quoteService: QuoteService?
    private let store: VehicleRulesStore
    private var rules: VehicleImageRules? {
        store.get()
    }
    
    private var onRulesUpdated: ((VehicleImageRules) -> Void)?
    
    init(
        quoteService: QuoteService? = Karhoo.getQuoteService(),
        store: VehicleRulesStore = KarhooVehicleRulesStore()
    ) {
        self.quoteService = quoteService
        self.store = store
    }
    
    private func handle(_ result: Result<VehicleImageRules>) {
        guard let rules = result.getSuccessValue() else {
            return
        }
        store.save(rules)
    }
    
    func update() {
        rulesUpdateInProgress = true
        quoteService?.getVehicleImageRules().execute { [weak self] result in
            self?.handle(result)
            self?.rulesUpdateInProgress = false
        }
    }
    
    func getRules(completion: @escaping (VehicleImageRules?) -> Void) {
        if rulesUpdateInProgress {
            onRulesUpdated = completion
        } else {
            completion(rules)
        }
    }
    
    func getRule(for quote: Quote, completion: @escaping (VehicleImageRule?) -> Void) {
        getRules { [weak self] vehicleRules in
            let vehicleImageRule = self?.findVehicleRule(for: quote, from: vehicleRules)
            completion(vehicleImageRule)
        }
    }
    
    private func findVehicleRule(
        for quote: Quote,
        from vehicleRules: VehicleImageRules?
    ) -> VehicleImageRule? {
        var fallbackRule: VehicleImageRule? {
            vehicleRules?.rules.first { $0.ruleType == .fallback }
        }
        
        var defaultTypeRule: VehicleImageRule? {
            vehicleRules?.rules.first { $0.type == quote.vehicle.type && $0.ruleType == .typeDefault }
        }
        
        var anyMatchingTagRule: VehicleImageRule? {
            var rule: VehicleImageRule?
            let rulesWithOneTag = vehicleRules?.rules.filter { $0.tags.count == 1 }
            quote.vehicle.tags
                .map { $0.lowercased() }
                .forEach { quoteTag in
                    guard rule == nil else { return }
                    rule = rulesWithOneTag?.first { ruleWithOneTag in
                        ruleWithOneTag.tags
                            .map { $0.lowercased() }
                            .contains(quoteTag.lowercased())
                    }
                }
            return rule
        }
        
        let specificRule = vehicleRules?.rules.first { rule in
            guard rule.ruleType == .specific else { return false }
            let ruleTags = Set(rule.tags.map { $0.lowercased() })
            let quoteVehicleTags = Set(quote.vehicle.tags.map { $0.lowercased() })
            return rule.type.lowercased() == quote.vehicle.type.lowercased() && ruleTags == quoteVehicleTags
        }
        
        var rule: VehicleImageRule? {
            if VehicleType(rawValue: quote.vehicle.type.uppercased()) == .moto {
                return defaultTypeRule
            } else {
                return (specificRule ?? anyMatchingTagRule) ?? (defaultTypeRule ?? fallbackRule)
            }
        }
        return rule
    }
}
