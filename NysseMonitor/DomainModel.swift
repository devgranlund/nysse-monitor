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
    
    // This function has a side effect: by setting json, also the  domain model is created.
    func buildDomainModelFromJSON(json: String){
        
        // Dirty trick to mutate original JSON message
        // - hard coded stop point short name as a JSON element key is replaced in
        // order to allow dynamic handling of different stop points' JSON messages
        let mutatedJson = json.replacingOccurrences(of: self.shortName, with: "lines")
        
        self.json = mutatedJson
        do {
            self.departures = try JSONDecoder().decode(Departures.self, from: mutatedJson.data(using: .utf8)!)
            self.departures?.removeUnwantedLines()
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
    var body: Body?
    
    private enum CodingKeys: String, CodingKey {
        case body = "body"
    }
    
    var getLines: [Line]{
        return self.body!.lines!
    }
    
    mutating func removeUnwantedLines() {
        self.body!.removeUnwantedLines()
    }
}

struct Body: Codable {
    var lines: [Line]?
    
    private enum CodingKeys: String, CodingKey {
        case lines = "lines"
    }
    
    mutating func removeUnwantedLines() {
        self.lines = self.lines!.filter {
            ($0.lineRef?.elementsEqual("1"))!
            ||
            ($0.lineRef?.elementsEqual("1A"))!
            ||
            ($0.lineRef?.elementsEqual("1B"))!
            ||
            ($0.lineRef?.elementsEqual("1C"))!
            ||
            ($0.lineRef?.elementsEqual("11"))!
            ||
            ($0.lineRef?.elementsEqual("11B"))!
            ||
            ($0.lineRef?.elementsEqual("11C"))!
        }
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
        let dateDate = self.getExpectedArrivalTimeDate
        return formatter.string(from: dateDate!)
    }
    
    var getExpectedArrivalTimeDate: Date? {
        
        let formatterWithFractional  = ISO8601DateFormatter()
        formatterWithFractional.formatOptions = [.withFractionalSeconds, .withInternetDateTime]
        let formatterWithoutFractional  = ISO8601DateFormatter()
        formatterWithoutFractional.formatOptions = [.withInternetDateTime]
        
        let date = formatterWithFractional.date(from: self.getExpectedArrivalTime) ?? formatterWithoutFractional.date(from: self.getExpectedArrivalTime)
        return date
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
