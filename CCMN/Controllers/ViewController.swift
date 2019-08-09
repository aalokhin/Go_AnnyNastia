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
    ///api/analytics/v1/now/connectedDetected
    @IBOutlet weak var imageMap: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getInit()
        getSiteID()
       // setFloorImgs()
        getConnectedVisitors("lastmonth")
       // getConnectedDevices()
       
        
        //getting the floors information
    
    }
    
    func getConnectedDevices(){
        
        let siteID = Client.sharedInstance.siteID?.aesUidString ?? "1513804707441"
        let urlPath = PresenceEndpoints.connectedDevicesUntilNow.rawValue + "?siteId=\(siteID)"
        print(urlPath)
        
        self.getRequestData(urlPath: urlPath, authHeader: ["Authorization" : Client.sharedInstance.presenceAuthHeader], params: [:], method: .get, completion: { data, error in
            if let d = data {
                print("request on getting connectedDevicesUntilNow info completed")
                print(d)
                let nbrConnectedDevicesToday =  String(data: d, encoding: .utf8)?.toInt()
                print("what we recieved in utf8: ", nbrConnectedDevicesToday ?? "nothing")
                
                /*
                 let json = try? JSONSerialization.jsonObject(with: d, options: [])
                 print(json ?? "serialization of json failed")
                 */
                //                let decoder = JSONDecoder()
                //                guard let t = try? decoder.decode([SiteID].self, from: d) else {
                //                    print("error decoding json")
                //                    return
                //                }
            }
            if let err = error{
                print(err.localizedDescription)
            }
        })
    }
    
    func getSiteID (){
        let auth = Client.sharedInstance.presenceAuthHeader
        let sitesURL = Client.sharedInstance.presenceUrl + "api/config/v1/sites"
        self.getRequestData(urlPath: sitesURL, authHeader: ["Authorization" : auth], params: [:], method: .get, completion: { data, error in
            if let d = data {
               // print("request on getting sites ID info completed")
                //let json = try? JSONSerialization.jsonObject(with: d, options: [])
                //print(json ?? "serialization of json failed")
                let decoder = JSONDecoder()
                guard let t = try? decoder.decode([SiteID].self, from: d) else {
                    print("error decoding json")
                    return
                }
                Client.sharedInstance.siteID = t[0]
                Client.sharedInstance.siteID?.printAll()

            }
        })
        
    }
    
    func getInit(){
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
        // /api/config/v1/sites
        urlPath = Client.sharedInstance.locateUrl + locationEndpoints.allFloors.rawValue
        
        
        getRequestData(urlPath: urlPath, authHeader : ["Authorization" : auth], params : parameters, method : .get, completion: { data, error in
            //if let error should be added
            if let d =  data{
                print("request on getting maps info completed")
                // print(d)
               // let json = try? JSONSerialization.jsonObject(with: d, options: [])
                //print(json ?? "serialization of json failed")
                
                let decoder = JSONDecoder()
                guard let t = try? decoder.decode(mapJSON.self, from: d) else {
                    print("error decoding json")
                    return
                }
               // t.printAllMapInfo()
                Client.sharedInstance.setCampus(t : t)
//                let url = locationEndpoints.firstFloorImg.rawValue
   
            }
        })
    }
    
    
    func setFloorImgs(){
        let floorsImgs = ["https://cisco-cmx.unit.ua/api/config/v1/maps/image/System%20Campus/UNIT.Factory/1st_Floor", "https://cisco-cmx.unit.ua/api/config/v1/maps/image/System%20Campus/UNIT.Factory/2nd_Floor", "https://cisco-cmx.unit.ua/api/config/v1/maps/image/System%20Campus/UNIT.Factory/3rd_Floor"]
        for i in 0..<3{
            //Client.sharedInstance.floorImgs?.append(UIImage())
            self.getImage(floorsImgs[i], [:] , completion: { image, error in
                if let img = image {
                    print("we've got an image")
                    Client.sharedInstance.floorImgs?.append(img)
                    self.imageMap.image = img
                }
            })
        }
    }
}
