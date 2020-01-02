//
//  NysseMonitorTests.swift
//  NysseMonitorTests
//
//  Created by tuomas.granlund on 2.1.2020.
//  Copyright © 2020 tuomas.granlund. All rights reserved.
//

import XCTest
@testable import NysseMonitor

class NysseMonitorTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //MARK: StopPoint Class Tests
    func testStopPointInitializationSucceeds() {
        let validStopPoint = StopPoint.init(url: "http://178.217.134.14/journeys/api/1/stop-points/2524",
                                            name: "Valmetinkatu",
                                            shortName: "2524")
        XCTAssertNotNil(validStopPoint)
    }
    
    func testStopPointInitializationFails() {
        let nonValidStopPoint = StopPoint.init(url: "http://178.217.134.14/journeys/api/1/stop-points/2558",
                                               name: "Valmetinkatu",
                                               shortName: "")
        XCTAssertNil(nonValidStopPoint)
    }
}
