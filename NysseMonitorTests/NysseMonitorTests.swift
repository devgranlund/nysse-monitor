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
        XCTAssertEqual(domainModel.stopPoints.count, 2)
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
    
    func testStopPointLineTimeHandling() {
        let rautatieasema = StopPoint.init(url: "http://178.217.134.14/journeys/api/1/stop-points/0505",
        monitoringUrl: "http://data.itsfactory.fi/journeys/api/1/stop-monitoring?stops=0505",
                                          name: "Rautatieasema",
        shortName: "0505")
        XCTAssertNotNil(rautatieasema)
        
        rautatieasema!.setJson(json: jsonResponse)
        XCTAssertNotNil(rautatieasema)
        
        let line0 = rautatieasema?.getDepartures?.getLines[0]
        XCTAssertNotNil(line0)
        XCTAssertEqual(line0?.getLineRef, "8")
        XCTAssertEqual(line0?.getExpectedArrivalTime, "2020-01-04T01:06:16.475+02:00")
        XCTAssertNotNil(line0?.getExpectedArrivalTimeDate)
        XCTAssertEqual(line0?.getExactExpectedArrivalTime, "01:06")
        
        let line1 = rautatieasema?.getDepartures?.getLines[1]
        XCTAssertNotNil(line1)
        XCTAssertEqual(line1?.getLineRef, "3A")
        XCTAssertEqual(line1?.getExpectedArrivalTime, "2020-01-04T02:30:57+02:00")
        XCTAssertNotNil(line1?.getExpectedArrivalTimeDate)
        //XCTAssertEqual(line1?.getExactExpectedArrivalTime, "02:30")
        
    }
    
    let jsonResponse = """
    {
      "status": "success",
      "data": {
        "headers": {
          "paging": {
            "startIndex": 0,
            "pageSize": 0,
            "moreData": false
          }
        }
      },
      "body": {
        "0505": [
          {
            "lineRef": "8",
            "directionRef": "0",
            "vehicleLocation": {
              "longitude": "23.8234406",
              "latitude": "61.5047836"
            },
            "operatorRef": "6921",
            "bearing": "242",
            "delay": "P0Y0M0DT0H0M20.000S",
            "vehicleRef": "130601",
            "journeyPatternRef": "8",
            "originShortName": "5249",
            "destinationShortName": "1668",
            "originAimedDepartureTime": "2020-01-04T00:45:00+02:00",
            "call": {
              "vehicleAtStop": false,
              "expectedArrivalTime": "2020-01-04T01:06:16.475+02:00",
              "expectedDepartureTime": "2020-01-04T01:06:20.475+02:00",
              "aimedArrivalTime": "2020-01-04T01:08:00+02:00",
              "aimedDepartureTime": "2020-01-04T01:08:00+02:00",
              "departureStatus": "early",
              "arrivalStatus": "early",
              "visitNumber": "21",
              "vehicleLocationAtStop": {
                "longitude": "23.8234406",
                "latitude": "61.5047836"
              }
            }
          },
          {
            "lineRef": "3A",
            "directionRef": "0",
            "vehicleLocation": {
              "longitude": "23.8432941",
              "latitude": "61.4640884"
            },
            "operatorRef": "6921",
            "bearing": "180",
            "delay": "P0Y0M0DT0H1M40.000S",
            "vehicleRef": "130620",
            "journeyPatternRef": "3A",
            "originShortName": "3615",
            "destinationShortName": "1028",
            "originAimedDepartureTime": "2020-01-04T00:47:00+02:00",
            "call": {
              "vehicleAtStop": false,
              "expectedArrivalTime": "2020-01-04T02:30:57+02:00",
              "expectedDepartureTime": "2020-01-04T01:11:51.972+02:00",
              "aimedArrivalTime": "2020-01-04T01:15:15+02:00",
              "aimedDepartureTime": "2020-01-04T01:15:15+02:00",
              "departureStatus": "early",
              "arrivalStatus": "early",
              "visitNumber": "23",
              "vehicleLocationAtStop": {
                "longitude": "23.8432941",
                "latitude": "61.4640884"
              }
            }
          },
          {
            "lineRef": "1",
            "directionRef": "0",
            "vehicleLocation": {
              "longitude": "23.9096889",
              "latitude": "61.4932899"
            },
            "operatorRef": "6921",
            "bearing": "267",
            "delay": "P0Y0M0DT0H0M11.000S",
            "vehicleRef": "130087",
            "journeyPatternRef": "1",
            "originShortName": "4600",
            "destinationShortName": "7016",
            "originAimedDepartureTime": "2020-01-04T00:50:00+02:00",
            "call": {
              "vehicleAtStop": false,
              "expectedArrivalTime": "2020-01-04T01:16:17+02:00",
              "expectedDepartureTime": "2020-01-04T01:16:19+02:00",
              "aimedArrivalTime": "2020-01-04T01:18:00+02:00",
              "aimedDepartureTime": "2020-01-04T01:18:00+02:00",
              "departureStatus": "early",
              "arrivalStatus": "early",
              "visitNumber": "28",
              "vehicleLocationAtStop": {
                "longitude": "23.9096889",
                "latitude": "61.4932899"
              }
            }
          }
        ]
      }
    }
    """
}
