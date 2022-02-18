//
//  PassengerDetailsMVP.swift
//  KarhooUISDK
//
//  Created by Jeevan Thandi on 08/07/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

public protocol PassengerDetailsView: BaseViewController {
    var delegate: PassengerDetailsDelegate? { get set }
    var details: PassengerDetails? { get set }
    var enableBackOption: Bool { get set }
}

protocol PassengerDetailsActions: BaseViewController {
    func passengerDetailsValid(_ : Bool)
}

public protocol PassengerDetailsDelegate: AnyObject {
    func didInputPassengerDetails(result: PassengerDetailsResult)
    func didCancelInput(byUser: Bool)
}

protocol PassengerDetailsPresenterProtocol {
    var delegate: PassengerDetailsDelegate? { get set }
    func doneClicked(newDetails: PassengerDetails, country: Country)
    func backClicked()
}

public struct PassengerDetailsResult {
    public var details: PassengerDetails?
    public var country: Country?
}
