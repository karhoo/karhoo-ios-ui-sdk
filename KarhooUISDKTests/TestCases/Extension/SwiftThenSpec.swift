//
//  SwiftThenSpec.swift
//  KarhooUISDKTests
//
//  Adjusted by Aleksander Wedrychowski on 03/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

//
//  ThenTests.swift
//  ThenTests
//
//  Created by 전수열 on 12/24/15.
//  Copyright © 2015 Suyeol Jeon. All rights reserved.
//
import KarhooUISDKTestUtils
import XCTest
@testable import KarhooUISDK

struct TestThenUserModel {
    var name: String?
    var email: String?
}
extension TestThenUserModel: Then {}

class SwiftThenSpec: KarhooTestCase {
    
    func testThen_NSObject() {
        let queue = OperationQueue().then {
            $0.name = "awesome"
            $0.maxConcurrentOperationCount = 5
        }
        XCTAssertEqual(queue.name, "awesome")
        XCTAssertEqual(queue.maxConcurrentOperationCount, 5)
    }
    
    func testWith() {
        let user = TestThenUserModel().with {
            $0.name = "devxoul"
            $0.email = "devxoul@gmail.com"
        }
        XCTAssertEqual(user.name, "devxoul")
        XCTAssertEqual(user.email, "devxoul@gmail.com")
    }
    
    func testWith_Array() {
        let array = [1, 2, 3].with { $0.append(4) }
        XCTAssertEqual(array, [1, 2, 3, 4])
    }
    
    func testWith_Dictionary() {
        let dict = ["Korea": "Seoul", "Japan": "Tokyo"].with {
            $0["China"] = "Beijing"
        }
        XCTAssertEqual(dict, ["Korea": "Seoul", "Japan": "Tokyo", "China": "Beijing"])
    }
    
    func testWith_Set() {
        let set = Set(["A", "B", "C"]).with {
            $0.insert("D")
        }
        XCTAssertEqual(set, Set(["A", "B", "C", "D"]))
    }
    
    func testDo() {
        UserDefaults.standard.do {
            $0.removeObject(forKey: "username")
            $0.set("devxoul", forKey: "username")
            $0.synchronize()
        }
        XCTAssertEqual(UserDefaults.standard.string(forKey: "username"), "devxoul")
    }
    
    func testRethrows() {
        XCTAssertThrowsError(
            try NSObject().do { _ in
                throw NSError(domain: "", code: 0)
            }
        )
    }
}
