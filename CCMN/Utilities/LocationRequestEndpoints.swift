//
//  RequestEndpoints.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 8/1/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation

//useful https://gist.github.com/murphykevin/f2b0ce6715cdc0eb2732e7478f6d9a4c

fileprivate let locateUrl = "https://cisco-cmx.unit.ua/"
fileprivate let presenceUrl = "https://cisco-presence.unit.ua/"

protocol locationEndpoint {
    var rawValue: String { get }
}

enum locationEndpoints: String {
    case clientsCount = "api/location/v2/clients/count"  // wireless clients
//  ************************************ floors images and maps ************************************
    case allFloors = "api/config/v1/maps/count"
    case imageMapReq = "api/config/v1/maps/image"
    case firstFloorImg = "api/config/v1/maps/image/System%20Campus/UNIT.Factory/1st_Floor"
    case secondFloorImg = "api/config/v1/maps/image/System%20Campus/UNIT.Factory/2nd_Floor"
    case thirdFloorImg = "api/config/v1/maps/image/System%20Campus/UNIT.Factory/3rd_Floor"
//  ************************************ floors images and maps ************************************


}



    



 
// "floorInfo" : ("https://cisco-cmx.unit.ua/api/config/v1/maps/count", "just4reading"),
// "mapImg" : ("https://cisco-cmx.unit.ua/api/config/v1/maps/image", "just4reading"),
// "clientsInfo" : ("https://cisco-cmx.unit.ua/api/location/v2/clients", "just4reading"),
//
//
//
// "siteId" : ("https://cisco-presence.unit.ua/api/config/v1/sites", "Passw0rd"),
// "mainInfo" : ("https://cisco-presence.unit.ua/api/presence/v1/kpisummary", "Passw0rd") ,
// //**************REPEAT VISITORS
// "repeatVisitors" : ("https://cisco-presence.unit.ua/api/presence/v1/repeatvisitors", "Passw0rd"),
//
// //**************DWELL TIME
// "dwellTime" : ("https://cisco-presence.unit.ua/api/presence/v1/dwell", "Passw0rd"),
//
// //**************PASSERSBY
// "passersby" : ("https://cisco-presence.unit.ua/api/presence/v1/passerby", "Passw0rd"),
//
// //**************VISITORS
// "visitors" : ("https://cisco-presence.unit.ua/api/presence/v1/visitor", "Passw0rd"),
//
// //**************CONNECTED
// "connected" : ("https://cisco-presence.unit.ua/api/presence/v1/connected", "Passw0rd"),
//
// //**************REPEAT_VISITORS_DISTRIBUTION
// "repeatVisitorsDistribution" : ("https://cisco-presence.unit.ua/api/presence/v1/repeatvisitors/count", "Passw0rd"),
//
// //*************PREDICTION
// "visitorsPrediction" : ("https://cisco-presence.unit.ua/api/presence/v1/visitor", "Passw0rd"),
// "passersbyPrediction" : ("https://cisco-presence.unit.ua/api/presence/v1/passerby", "Passw0rd"),
// "connectedPrediction" : ("https://cisco-presence.unit.ua/api/presence/v1/connected", "Passw0rd")
// ]
//
// var timeParams : [String : (String, String)] = [
// "Today" : ("/today", "/hourly/today"),
// "Yesterday" : ("/yesterday", "/hourly/yesterday"),
// "Last 3 days" : ("/3days", "/hourly/3days"),
// "Last 7 days" : ("/lastweek", "/daily/lastweek"),
// "Last 30 days" : ("/lastmonth", "/daily/lastmonth"),
// "Custom" : ("", "/daily"),
// "hourly" : ("", "/hourly")
// ]
//

