//
//  ViewController.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 7/28/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    //this shit helps us a  lot
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //test()
        
        
        var parameters : Parameters = [
            "" : ""
        ]
        var urlPath : String = Client.sharedInstance.locateUrl +  locationEndpoints.clientsCount.rawValue
        var auth = Client.sharedInstance.locateAuthHeader
        
 
        self.performRequest(urlPath : urlPath, authHeader : ["Authorization" : auth], params : parameters, method : .get){ complete in
            if complete {
                print("request completed")
            }
            else {
                print("some error completing task")
            }
        }
        
        //https://cisco-cmx.unit.ua/api/config/v1/maps/image
        
        parameters = ["date" : "2019/08/02", "username" : "aalokhin"]
        
        
        self.performRequest(urlPath : "https://cisco-cmx.unit.ua/api/location/v1/historylite/byusername/aalokhin", authHeader : ["Authorization" : auth], params : parameters, method : .get){ complete in
            if complete {
                print("request2 completed")
            }
            else {
                print("some error completing request2")
            }
        }
        
        /*
         date
         Y
         —
         String
         query
         Date in format of yyyy/mm/dd
         username
         Y
         —
         String
         pathReplace
         User name.
 */
        // Do any additional setup after loading the view.
    }
    
    
    //IT WORKED FUCKAS!!!!!
    
    
}



/*    _ url: URLConvertible,
 method: HTTPMethod = .get,
 parameters: Parameters? = nil,
 encoding: ParameterEncoding = URLEncoding.default,
 headers: HTTPHeaders? = nil)
 */

