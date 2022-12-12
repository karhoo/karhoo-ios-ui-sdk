//
//  PrimitiveUtil.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import CoreLocation

class PrimitiveUtil {

    class func getRandomLocation() -> CLLocation {
        CLLocation(latitude: getRandomCoordinateComponent(),
                          longitude: getRandomCoordinateComponent())
    }

    class func getRandomCoordinateComponent() -> CLLocationDegrees {
        CLLocationDegrees(arc4random_uniform(1000)/10)
    }

    class func getRandomString() -> String {
        String(arc4random_uniform(1000))
    }

    class func getRandomLabel(length: Int? = nil) -> String {
        let digits = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let lengthOfString = length ?? Int.random(in: 3...10)
        return String(Array(0..<lengthOfString).map { _ in digits.randomElement()! })
    }

    class func getRandomEmail() -> String {
        getRandomLabel() + "@" + getRandomLabel() + "." + getRandomLabel()
    }

    class func gerRandomPhoneNumber() -> String {
        let digits = "0123456789"
        return "+4822" + String(Array(0...6).map { _ in digits.randomElement()! })
    }

    class func getRandomInt(lessThan: UInt32 = UInt32(INT_MAX)) -> Int {
        Int(arc4random_uniform(UInt32(lessThan)))
    }

    class func getTestDate() -> Date { // Wednesday, 14 March 2018 16:20:44
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter.timeZone = TimeZone.current
        return formatter.date(from: "2018/03/14 16:20:44")!
    }

    class func getRandomDate(laterThan date: Date = Date()) -> Date {
        let timeInterval = date.timeIntervalSince1970 + TimeInterval(arc4random_uniform(10000000))
        return Date(timeIntervalSince1970: timeInterval)
    }
}
