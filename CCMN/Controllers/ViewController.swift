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
    
    
    
    
    func test(){
        let path = "https://projects.intra.42.fr/uploads/document/document/312/ligands.txt"
        Alamofire.request(path).responseJSON { response in
            guard response.result.isSuccess else {
                print("Ошибка при запросе данных \(String(describing: response.result.error))")
                return
            }
          //  print(response)
        }
    }
        
    func testRequestLocate(){
      //  let urlPath : String = "https://cisco-cmx.unit.ua/api/location/v2/clients/count"
        
        
        let urlPath : String = "https://cisco-cmx.unit.ua/api/location/v2/clients/count"
        let url = URL(string: urlPath)
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
            }
        }
    }
}
