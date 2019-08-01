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
        self.testRequestLocate()
        // Do any additional setup after loading the view.
    }
    //IT WORKED FUCKAS!!!!!
    func testRequestLocate(){
      //  let urlPath : String = "https://cisco-cmx.unit.ua/api/location/v2/clients/count"
        let urlPath : String = "https://cisco-cmx.unit.ua/" +  locationEndpoints.clientsCount.rawValue
        
        let auth = Client.sharedInstance.locateAuthHeader
        Client.sharedInstance.manager.request(urlPath, method: .get, headers: ["Authorization": auth]).validate().responseJSON { response in
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
