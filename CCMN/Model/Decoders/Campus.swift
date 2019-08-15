//
//  Campus.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 8/6/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation

class Campus {
    let campusName : String
    let buildingName : String
    let floorName : [String]
    
    init(campusName : String, buildingName : String, floorName : [String]) {
        self.campusName = campusName
        self.buildingName = buildingName
        self.floorName = floorName
    }
}

/*
Content Type
application/json
Configuration

Name
Required
Default
Type
Location
Description
campusName
Y
—
String
pathReplace
Campus Name.
buildingName
Y
—
String
pathReplace
Building Name.
floorName
Y
—
String
pathReplace
Floor Name.

 */
