//
//  QuoteSortMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol QuoteSortView: AnyObject { }

protocol QuoteSortViewActions: AnyObject {

    func didSelectQuoteOrder(_ order: QuoteSortOrder)
}
