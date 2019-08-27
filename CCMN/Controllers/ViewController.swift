//
//  ViewController.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 7/28/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import UIKit
import Alamofire
import Charts


class ViewController: UIViewController {
    
    //this shit helps us a  lot
    ///api/analytics/v1/now/connectedDetected
    let periods = [ "today", "yesterday", "3days", "lastweek", "lastmonth" ]
    
    var startDate : String = Date().toStringDefault()
    var endDate : String =  Date().toStringDefault()
    
    

    @IBOutlet weak var imageMap: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //getInit()
        getSiteID()
        //forToday()
        
        /*
         cisco-presence.unit.ua/api/presence/v1/visitor/count/today?siteId=1513804707441
         cisco-presence.unit.ua/api/presence/v1/dwell/average/today?siteId=1513804707441
         cisco-presence.unit.ua/api/presence/v1/kpisummary/today?siteId=1513804707441
 
 
 */
       // testPresenceConnect()
//        testPresenceRepeat()
        setFloorImgs()
      //  getConnectedDevices()
       
        
        //getting the floors information
    
    }
    
    
    
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        
    }
    
    func forToday(){
        
        
        NetworkManager.getRequestData(isLocation: false, endpoint: "api/presence/v1/visitor/count/today?siteId=1513804707441", params: [:], method: .get, completion: {
            data, error in
            if let d = data{
              //  print("count/today")
//                let json = try? JSONSerialization.jsonObject(with: d, options: [])
//                print(json ?? "serialization of json failed\n\n")
                 let nbr = String(data: d, encoding: .utf8)?.toInt()
                print("count/today visitors \(nbr ?? -1)\n\n")
            }
        })
        
      
        
        NetworkManager.getRequestData(isLocation: false, endpoint: "api/presence/v1/kpisummary/today?siteId=1513804707441", params: [:], method: .get, completion: {
            data, error in
            if let d = data{
                print("kpisummary/today\n\n")
                
            if let json = try? JSONSerialization.jsonObject(with: d, options: []){
                print(json)
            }
            
                if let nbr = String(data: d, encoding: .utf8)?.toInt(){
                    print("kpi summary  \(nbr)\n\n")
                }
                }
            
        })
        
        
    }
    
    
    @IBAction func goToVisualization(_ sender: UIButton) {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        testPresenceConnect()
    }
    
    func testPresenceRepeat(){
        let siteID = Client.sharedInstance.siteID?.aesUidString ?? "1513804707441"
        print("repeeeeeeeeeat count for periods ===================================================")

        for one in self.periods{
            NetworkManager.getRequestData(isLocation : false, endpoint : "api/presence/v1/repeatvisitors/count/\(one)?siteId=\(siteID)", params: [:], method: .get, completion: {
            data, error in
            if let d = data{
                print("repeeeeeeeeeat ==============  \(one)  =====================================")

                let json = try? JSONSerialization.jsonObject(with: d, options: [])
                print(json ?? "serialization of json failed")
               // print("repeeeeeeeeeat ===================================================")

                }
            })
        }
        
        
        print("repeeeeeeeeeat ========================================")

        NetworkManager.getRequestData(isLocation: false, endpoint: "api/presence/v1/repeatvisitors/count?siteId=\(siteID)", params: [:], method: .get, completion: {
            data, error in
            if let d = data{
                
                let json = try? JSONSerialization.jsonObject(with: d, options: [])
                print(json ?? "serialization of json failed")
            //    print("repeeeeeeeeeat ===================================================")
                
            }
        })
        
        
        //&startDate=<date in yyyy-mm-dd>&endDate=<date in yyyy-mm-dd> dweell time done we can add some tdate picker here and it might wanna work after that
        
    }
    
    
    
    
    func testPresenceConnect(){
        let siteID = Client.sharedInstance.siteID?.aesUidString ?? "1513804707441"
        var connectedVisitorsTotalOverPeriod : [[String : Int]] = []
/*
        for one in self.periods {
            NetworkManager.getRequestData(isLocation: false, endpoint: "api/presence/v1/connected/total/\(one)?siteId=\(siteID)", params: [:], method: .get, completion: {
                data, error in
                if let d = data{
                    let nbr = String(data: d, encoding: .utf8)?.toInt()
                    connectedVisitorsTotalOverPeriod.append([one : nbr ?? -1])
                    print(connectedVisitorsTotalOverPeriod)
                    
                    
                }
            })
            
        }
*/
        //&startDate=<date in yyyy-mm-dd>&endDate=<date in yyyy-mm-dd> dweell time done we can add some tdate picker here and it might wanna work after that
        
//        let startDate = "2019-06-01"
//        let endDate = "2019-08-01"

        NetworkManager.getRequestData(isLocation: false, endpoint: "api/presence/v1/connected/total?siteId=\(siteID)&startDate=\(self.startDate)&endDate=\(self.endDate)", params: [:], method: .get, completion: {
                data, error in
             print("=\(self.startDate)&endDate=\(self.endDate)")
            if let d = data{
                

                let nbr = String(data: d, encoding: .utf8)?.toInt()
                print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", nbr ?? "nothing received")
                
                
            }
        })
    }
    
//    "Today" : ("/today", "/hourly/today"),
//    "Yesterday" : ("/yesterday", "/hourly/yesterday"),
//    "Last 3 days" : ("/3days", "/hourly/3days"),
//    "Last 7 days" : ("/lastweek", "/daily/lastweek"),
//    "Last 30 days" : ("/lastmonth", "/daily/lastmonth"),
//    "Custom" : ("", "/daily"),
//    "hourly" : ("", "/hourly")
    
    func getConnectedDevices(){
        
        let siteID = Client.sharedInstance.siteID?.aesUidString ?? "1513804707441"
        let urlPath = PresenceEndpoints.connectedDevicesUntilNow.rawValue + "?siteId=\(siteID)"
        print(urlPath)
        
        NetworkManager.getRequestData(isLocation: false, endpoint: PresenceEndpoints.connectedDevicesUntilNow.rawValue, params: [:], method: .get, completion: { data, error in
            if let d = data {
                print("request on getting connectedDevicesUntilNow info completed")
                print(d)
                let nbrConnectedDevicesToday =  String(data: d, encoding: .utf8)?.toInt()
                print("what we recieved in utf8: ", nbrConnectedDevicesToday ?? "nothing")
            }
            if let err = error{
                print(err.localizedDescription)
            }
        })
    }
    
    func getSiteID (){

        NetworkManager.getRequestData(isLocation: false, endpoint: "api/config/v1/sites", params: [:], method: .get, completion: { data, error in
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
               // Client.sharedInstance.siteID?.printAll()

            }
        })
        
    }
    
    func getInit(){
        let parameters : Parameters = ["" : ""]
        NetworkManager.getRequestData(isLocation : true, endpoint : locationEndpoints.clientsCount.rawValue, params : parameters, method : .get, completion:  { data, error in
            if let d =  data{
                print("request clients count  completed")
                 let json = try? JSONSerialization.jsonObject(with: d, options: [])
                print(json ?? "serialization of json failed")
            }
            else {
                print("some error completing task")
            }
        })
        
        
        NetworkManager.getRequestData(isLocation : true, endpoint : locationEndpoints.allFloors.rawValue, params : parameters, method : .get, completion: { data, error in
            //if let error should be added
            if let d =  data{
                print("request on getting campus info completed")
         
                let decoder = JSONDecoder()
                guard let t = try? decoder.decode(mapJSON.self, from: d) else {
                    print("error decoding json")
                    return
                }
                Client.sharedInstance.setCampus(t : t)
            }
        })
    }
    
    
    func setFloorImgs(){
        let floorsImgs = ["api/config/v1/maps/image/System%20Campus/UNIT.Factory/1st_Floor", "api/config/v1/maps/image/System%20Campus/UNIT.Factory/2nd_Floor", "api/config/v1/maps/image/System%20Campus/UNIT.Factory/3rd_Floor"]
        for i in 0..<3{
            //Client.sharedInstance.floorImgs?.append(UIImage())
             NetworkManager.getImage(floorsImgs[i], [:] , completion: { image, error in
                if let img = image {
                    print("we've got an image")
                    Client.sharedInstance.floorImgs?.append(img)
                    self.imageMap.image = img
                }
            })
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
            /*not using right now but lets leave it for now*/
        case "testVis":
            print("testVis")
        case "locationVCSegue":
            print("locationVCSegue")
        default:
            print("unexpected segue identifier")
        }
    }
}
