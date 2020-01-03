//
//  DomainModel.swift
//  NysseMonitor
//
//  Created by tuomas.granlund on 3.1.2020.
//  Copyright © 2020 tuomas.granlund. All rights reserved.
//

import UIKit

class DomainModel {
    
    var stopPoints: [StopPoint] = []
    
    init() {
        
        // Valmentinkatu to the city centrum
        let valmetinkatu = StopPoint.init(url: "http://178.217.134.14/journeys/api/1/stop-points/2524",
        monitoringUrl: "http://data.itsfactory.fi/journeys/api/1/stop-monitoring?stops=2524",
                                          name: "Valmetinkatu",
        shortName: "2524")
        stopPoints.append(valmetinkatu!)
        
        // Rautatieasema to Valmetinkatu
        let rautatieasema = StopPoint.init(url: "http://178.217.134.14/journeys/api/1/stop-points/0505",
        monitoringUrl: "http://data.itsfactory.fi/journeys/api/1/stop-monitoring?stops=0505",
                                          name: "Rautatieasema",
        shortName: "0505")
        stopPoints.append(rautatieasema!)
    }
}

class StopPoint: Hashable {

    private var url: String
    private var monitoringUrl: String
    private var name: String
    private var shortName: String
    
    var json: String
    private var departures: Departures?

    init?(url: String, monitoringUrl:String, name: String, shortName: String) {
        if (url.isEmpty || monitoringUrl.isEmpty || name.isEmpty || shortName.isEmpty) {
                return nil
            }
            self.url = url
            self.monitoringUrl = monitoringUrl
            self.name = name
            self.shortName = shortName
            
            self.json = ""
        }
    
    var getName: String {
        return self.name
    }
    
    var getMonitoringUrl: String {
        return self.monitoringUrl
    }
    
    var getDepartures: Departures? {
        return self.departures
    }
    
    func setJson(json: String){
        self.json = json
        do {
            self.departures = try JSONDecoder().decode(Departures.self, from: json.data(using: .utf8)!)
        } catch {
            print(error)
        }
    }
    
    // Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(shortName)
    }
    
    // Equatable
    static func ==(lhs: StopPoint, rhs: StopPoint) -> Bool {
        return lhs.shortName == rhs.shortName
    }
}

struct Departures: Codable {
    let body: Body?
    
    private enum CodingKeys: String, CodingKey {
        case body = "body"
    }
    
    var getLines: [Line]{
        return self.body!.lines!
    }
}

struct Body: Codable {
    let lines: [Line]?
    
    private enum CodingKeys: String, CodingKey {
        case lines = "2524" // TODO 2524    
    }
}

struct Line: Codable, Hashable {
    
    let lineRef: String?
    let call: Call?
    
    private enum CodingKeys: String, CodingKey {
        case lineRef = "lineRef"
        case call = "call"
    }
    
    var getInfo: String {
        let info = self.lineRef! + " -> " + self.call!.getInfo
        return info
    }
    
    var getLineRef: String {
        return self.lineRef!
    }
    
    var getArrivalStatus: String {
        return self.call!.arrivalStatus!
    }
    
    var getExpectedArrivalTime: String {
        return self.call!.expectedArrivalTime!
    }
    
    var getExactExpectedArrivalTime: String {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: getExpectedArrivalTimeDate)
    }
    
    var getExpectedArrivalTimeDate: Date {
        let formatter  = ISO8601DateFormatter()
        return formatter.date(from: getExpectedArrivalTime)!
    }
    
    // Equatable
    static func == (lhs: Line, rhs: Line) -> Bool {
        return (lhs.getLineRef == rhs.getLineRef) && (lhs.getExpectedArrivalTime == rhs.getExpectedArrivalTime)
    }
    
    // Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.getLineRef)
    }
}

struct Call: Codable {
    let expectedArrivalTime: String?
    let aimedArrivalTime: String?
    let arrivalStatus: String?
    
    private enum CodingKeys: String, CodingKey {
        case expectedArrivalTime = "expectedArrivalTime"
        case aimedArrivalTime = "aimedArrivalTime"
        case arrivalStatus = "arrivalStatus"
     }
    
    var getInfo: String {
        var info = self.expectedArrivalTime! + ", "
        info += self.arrivalStatus! + " ("
        info += self.aimedArrivalTime! + ") "
        return info
    }
}
