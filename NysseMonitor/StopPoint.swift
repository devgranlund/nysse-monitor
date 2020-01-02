//
//  StopPoint.swift
//  NysseMonitor
//
//  Created by tuomas.granlund on 2.1.2020.
//  Copyright © 2020 tuomas.granlund. All rights reserved.
//

import UIKit

class StopPoint {
    
    var url: String
    var name: String
    var shortName: String
    // linjat
    
    init?(url: String, name: String, shortName: String) {
        if (url.isEmpty || name.isEmpty || shortName.isEmpty) {
            return nil
        }
        self.url = url
        self.name = name
        self.shortName = shortName
    }
    
    
}
