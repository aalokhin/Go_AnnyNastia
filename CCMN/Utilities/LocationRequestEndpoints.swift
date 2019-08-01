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

protocol locationEndpoint {
    var rawValue: String { get }
}

enum locationEndpoints: String, locationEndpoint {
    case clientsCount = "api/location/v2/clients/count"
  
    
//    static func deleteMessage(id: Int) -> String {
//        return "v2/messages/\(id)"
//    }
    
}


