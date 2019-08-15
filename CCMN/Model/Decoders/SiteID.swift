//
//  SiteID.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 8/8/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation

class SiteID : Decodable {
    let address : String?
    let aesUId : Int?
    let aesUidString : String?
    let apCount : Int?
    let applyExclusion : Bool?
    let currentTime : String?
    let name : String?
    let timezone : String?
    
    enum CodingKeys: String, CodingKey {
        case address = "address"
        case aesUId = "aesUId"
        case aesUidString = "aesUidString"
        case apCount = "apCount"
        case applyExclusion = "applyExclusion"
        case currentTime = "currentTime"
        case name = "name"
        case timezone = "timezone"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.address = (try? values.decode(String.self, forKey: .address))
        self.aesUId = (try? values.decode(Int.self, forKey: .aesUId))
        self.aesUidString = (try? values.decode(String.self, forKey: .aesUidString))
        self.apCount = (try? values.decode(Int.self, forKey: .apCount))
        self.applyExclusion = (try? values.decode(Bool.self, forKey: .applyExclusion))
        self.currentTime = (try? values.decode(String.self, forKey: .currentTime))
        self.name = (try? values.decode(String.self, forKey: .name))
        self.timezone = (try? values.decode(String.self, forKey: .timezone))
        
    }
    
}

extension SiteID {
    func printAll(){
        print("address \(address ?? "no address")")
        print("aesUId \(aesUId ?? -1)")
        print("aesUidString \(aesUidString  ?? "no aesUidString")")
        print("apCount \(apCount ?? -1)")
        print("applyExclusion \(applyExclusion ?? false)")
        print("currentTime \(currentTime ?? "no currentTime")")
        print("name \(name ?? "no name ")")
        print("timezone \(timezone ?? "no timezone")")
 
    }
}

/*
{
    address = "Kiev, Semii Khohlovih 8";
    aesUId = 1513804707441;
    aesUidString = 1513804707441;
    apCount = 5;
    applyExclusion = 0;
    aps = ();
    changedOn = 0;
    currentTime = "Aug 8, 2019 4:03:53 PM";
    description = "<null>";
    examinePeriod = 900000;
    exclusionParams = "<null>";
    latitude = 0;
    longitude = 0;
    minDuration = 300000;
    name = UNIT;
    objectVersion = 0;
    rssiThresholdHigh = "-65";
    rssiThresholdLow = "-95";
    tagList = "<null>";
    tags = "<null>";
    timezone = "Europe/Kiev";
}

*/
