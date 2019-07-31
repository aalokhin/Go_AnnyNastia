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
    var manager : SessionManager = {
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "cisco-cmx.unit.ua": .disableEvaluation
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //test()
        self.testRequestLocate()
        // Do any additional setup after loading the view.
    }
    //IT WORKED FUCKAS!!!!!
    func testRequestLocate(){
      //  let urlPath : String = "https://cisco-cmx.unit.ua/api/location/v2/clients/count"
        let urlPath : String = "https://cisco-cmx.unit.ua/api/location/v2/clients/count"
        let auth = "Basic " + String("RO:" + "just4reading").toBase64()
        
        manager.request(urlPath, method: .get, headers: ["Authorization": auth]).validate().responseJSON { response in
            switch response.result {
                
            case .success:
                if let value = response.result.value {
                    print(value)
                    print("success")
                }
            case .failure(let error):
               print("failure")
               print(error)
            }
        }
    }
}
