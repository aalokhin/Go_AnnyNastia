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
    
    
    @IBOutlet weak var imageMap: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let floorImgs : [UIImage]?
        let parameters : Parameters = ["" : ""]
        var urlPath : String = Client.sharedInstance.locateUrl +  locationEndpoints.clientsCount.rawValue
        let auth = Client.sharedInstance.locateAuthHeader
        
        self.performRequest(urlPath : urlPath, authHeader : ["Authorization" : auth], params : parameters, method : .get){ complete in
            if complete {
                print("request completed")
            }
            else {
                print("some error completing task")
            }
        }
        
        urlPath = Client.sharedInstance.locateUrl + locationEndpoints.allFloors.rawValue
       
        //getting the floors information
        getRequestData(urlPath: urlPath, authHeader : ["Authorization" : auth], params : parameters, method : .get, completion: { data, error in
            //if let error should be added
                if let d =  data{
                    print("request on getting maps info completed")
                   // print(d)
                     let json = try? JSONSerialization.jsonObject(with: d, options: [])
                    print(json ?? "serialization of json failed")
                    
                    let decoder = JSONDecoder()
                    guard let t = try? decoder.decode(mapJSON.self, from: d) else {
                        print("error decoding json")
                        return
                    }
                    t.printAllMapInfo()
                    Client.sharedInstance.setCampus(t : t)
                    let url = locationEndpoints.firstFloorImg.rawValue
                    self.setImageForImgView(url, [:],  self.imageMap)
                    
                }
            })
        
           
        }
    
   



}
