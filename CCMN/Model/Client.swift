//
//  Client.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 7/29/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//
/*
 
 Cisco_CMX_Locate:
 URL: "https://cisco-cmx.unit.ua"
 Username: "RO"
 Password: "just4reading"
 
 Cisco_CMX_Presence:
 URL: "https://cisco-presence.unit.ua"
 Username: "RO"
 Password: "Passw0rd"
 
 
 GETThis API returns all clients/api/location/v2/clients
 This API supports searching by ipv4/ipv6, mac-address and username. Here are some examples to illustrate this behavior.
 
 Search by IPv4/IPv6: api/location/v2/clients?ipAddress=x.x.x.x
 Search by Mac Address: api/location/v2/clients?macAddress=x:x:x:x
 Search by Username: api/location/v2/clients?username=someUsername
 
 This API also supports pagination based on page and page size.
 
 Pagination: api/location/v2/clients?include=metadata&page=x&pageSize=x
 
 As long as there is data you can keep paginating by incrementing the page and the pageSize numbers.pageSize is between 0 and 1000. Default pageSize is 1000.
 
 
 

 
 */
import Foundation
import Alamofire

final class Client {
    let aalokhin = "aalokhin"
    let gdanylov = "gdanylov"
    static let locateUrl = "https://cisco-cmx.unit.ua/"
    static let presenceUrl = "https://cisco-presence.unit.ua/"
    static let username = "RO"
    static let locatePass = "just4reading" // we will need to take password from application later bu for now we'll hardcode it in here
    static let presencePass = "Passw0rd"
    
    var manager : SessionManager = {
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "cisco-cmx.unit.ua" : .disableEvaluation,
            "cisco-presence.unit.ua" : .disableEvaluation
        ]
        
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
        return manager
    }()
    /* For e1r4p18  madAddr 38:c9:86:1c:37:7f  */
    static let macAddress = "38:c9:86:1c:37:7f"
    
 
    let searchByMacAddress = "https://cisco-cmx.unit.ua/api/location/v2/clients?macAddress=\(macAddress)" // GET
    let searchByUser = "https://cisco-cmx.unit.ua/api/location/v2/clients?username=aalokhin"
    
    
    static let sharedInstance = Client()
    
    private init(){
        print("Singleton client has been initialized")
    
    }
    
 
}
