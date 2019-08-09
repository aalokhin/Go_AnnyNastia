//
//  PresenceEndpoints.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 8/9/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
//https://<tenant-id>.cmxcisco.com/api/presence/v1/connected/count/today?siteId=<Site ID>

protocol PresenceEndpoint {
    var rawValue: String { get }
}

enum PresenceEndpoints: String, locationEndpoint {
    case connectedDevicesUntilNow = "https://cisco-presence.unit.ua/api/presence/v1/connected/count/today"
    //  ************************************ floors images and maps ************************************
    
    
}
