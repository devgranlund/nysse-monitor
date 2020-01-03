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
    
    //MARK: DomainObject Class Tests
    func testDomainObjectInitializationSucceeds() {
        let domainModel = DomainModel()
        XCTAssertNotNil(domainModel)
        
        // domain model has correct number of stop points
        XCTAssertEqual(domainModel.stopPoints.count, 1)
    }
    
    //MARK: StopPoint Class Tests
    func testStopPointInitializationSucceeds() {
        let validStopPoint = StopPoint.init(url: "http://178.217.134.14/journeys/api/1/stop-points/2524",
                                            monitoringUrl: "http://data.itsfactory.fi/journeys/api/1/stop-monitoring?stops=2524",
                                            name: "Valmetinkatu",
                                            shortName: "2524")
        XCTAssertNotNil(validStopPoint)
    }
    
    func testStopPointInitializationFails() {
        let nonValidStopPoint = StopPoint.init(url: "http://178.217.134.14/journeys/api/1/stop-points/2558",
                                               monitoringUrl: "http://data.itsfactory.fi/journeys/api/1/stop-monitoring?stops=2558",
                                               name: "Valmetinkatu",
                                               shortName: "")
        XCTAssertNil(nonValidStopPoint)
    }
}
