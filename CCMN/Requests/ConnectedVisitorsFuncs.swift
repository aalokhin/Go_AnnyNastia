//
//  ConnectedVisitorsFuncs.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 8/9/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
//"https://cisco-presence.unit.ua/"

// Analytics and Presence (Sum of Connected Visitor, number of repeat visitors over all available ranges, dwell time);
// https://<tenant-id>.cmxcisco.com/api/presence/v1/connected/total/3days?siteId=<Site ID>
// https://<tenant-id>.cmxcisco.com/api/presence/v1/connected/total/lastweek?siteId=<Site ID>
// https://<tenant-id>.cmxcisco.com/api/presence/v1/connected/total/lastmonth?siteId=<Site ID>
///api/presence/v1/connected/total  === >
//https://<tenant-id>.cmxcisco.com/api/presence/v1/connected/total/?siteId=<Site ID>&startDate=<date in
//yyyy-mm-dd>&endDate=<date in yyyy-mm-dd>

extension ViewController {
//    
//    func getConnectedVisitors(_ period : String) {
//        let siteID = Client.sharedInstance.siteID?.aesUidString ?? "1513804707441"
//        var nbrConnectedDevices : Int?
//        let url = "https://cisco-presence.unit.ua/api/presence/v1/connected/total/\(period)?siteId=\(siteID)"
//        self.getRequestData(urlPath: url, authHeader:["Authorization" : Client.sharedInstance.presenceAuthHeader], params: [:], method: .get, completion: { data, error in
//            if let d = data {
//                let nbr =  String(data: d, encoding: .utf8)?.toInt()
//                
//                print("what we recieved in from \(period) utf8: ", nbr ?? "nothing")
//                //return nbrConnectedDevices
//            }
//            else if let err = error {
//                print(err.localizedDescription)
//            }
//        })
//    }
}
