//
//  BaseTestCase.swift
//  AppTests
//
//  Created by Yiqiang Zeng on 2019/2/26.
//

import XCTest
import Foundation

class BaseTestCase: XCTestCase {
    
    ///MARK: - 睡眠
    func sleep(_ time: Double) {
        let _ = expectation(description: "")
        waitForExpectations(timeout: time as TimeInterval, handler: nil)
    }
}
