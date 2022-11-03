//
//  PrimitiveUtil.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import CoreLocation

public class PrimitiveUtil {

    public class func getRandomLocation() -> CLLocation {
        return CLLocation(latitude: getRandomCoordinateComponent(),
                          longitude: getRandomCoordinateComponent())
    }

    public class func getRandomCoordinateComponent() -> CLLocationDegrees {
        return CLLocationDegrees(arc4random_uniform(1000)/10)
    }

    public class func getRandomString() -> String {
        return String(arc4random_uniform(1000))
    }

    public class func getRandomInt(lessThan: UInt32 = UInt32(INT_MAX)) -> Int {
        return Int(arc4random_uniform(UInt32(lessThan)))
    }

    public class func getRandomBool() -> Bool {
        return Bool(truncating: Int.random(in: 0...1) as NSNumber)
    }

    public class func getTestDate() -> Date { // Wednesday, 14 March 2018 16:20:44
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter.timeZone = TimeZone.current
        return formatter.date(from: "2018/03/14 16:20:44")!
    }

    public class func getRandomDate(laterThan date: Date = Date()) -> Date {
        let timeInterval = date.timeIntervalSince1970 + TimeInterval(arc4random_uniform(10000000))
        return Date(timeIntervalSince1970: timeInterval)
    }
}
