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
        
        
        let parameters : Parameters = [
            "" : ""
        ]
        let urlPath : String = Client.sharedInstance.locateUrl +  locationEndpoints.clientsCount.rawValue
        let auth = Client.sharedInstance.locateAuthHeader
        
 
        self.performRequest(urlPath : urlPath, authHeader : ["Authorization" : auth], params : parameters, method : .get){ complete in
            if complete {
                print("request completed")
            }
            else {
                print("some error completing task")
            }
        }
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

