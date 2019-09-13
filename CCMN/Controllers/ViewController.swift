//
//  ViewController.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 7/28/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

// https://www.scalyr.com/blog/getting-started-swift-logging/ <== logging described


/*
 Every iOS app gets a slice of storage just for itself, meaning that you can read and write your app's files there without worrying about colliding with other apps. This is called the user's documents directory, and it's exposed both in code (as you'll see in a moment) and also through iTunes file sharing.
 
 Unfortunately, the code to find the user's documents directory isn't very memorable, so I nearly always use this helpful function – and now you can too!
 
 func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
 }
 */
import UIKit
import Alamofire
import Charts
import SwiftEntryKit
import SQLite3


class ViewController: UIViewController {
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
         getPrimaryData()
    }
    
    
    //this shit helps us a  lot
    ///api/analytics/v1/now/connectedDetected
    let labelsVsImages : [String] = ["total", "totalConnected", "totalPasserby", "avgDwell", "peakHour", "conversionRate", "topManufacturer", "connectedPercentage"]
    var startDate : String = Date().toStringDefault()
    var endDate : String =  Date().toStringDefault()
    var labelsForStatistics = [String : AnyObject]()
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //query()
        self.tableView.rowHeight = 150
        getPrimaryData()
    }
    
    func getPrimaryData(){
        for one in self.view.subviews{
            one.isHidden = true
        }
        
        KPIforToday(completion: {
            loaded, error in
            if loaded == true && error == nil{
                self.tableView.reloadData()
            }
            else if let err = error {
                self.logError(timestamp: Int32(Date().getTimeStamp()), ErrorMsg: NSString(string: err.localizedDescription))
                
            }
            
        })
        getSiteID(complete: {
            canLoad, error in
            if canLoad == true{
                self.getInitialLocationData(complete: {
                    canLoad2, error2 in
                    if canLoad2 == true{
                        for one in self.view.subviews{
                            one.isHidden = false
                        }
                        
                    }
                    else if let err2 = error2 {
                        self.logError(timestamp: Int32(Date().getTimeStamp()), ErrorMsg: "Error from Initial View Controller. Details: \(err2.localizedDescription)" as NSString)
                        self.callErrorWithCustomMessage("Something went wrong with loading data")
                    }
                })
                
            }
            else if let err = error{
                self.logError(timestamp: Int32(Date().getTimeStamp()), ErrorMsg: "Error from Initial View Controller. Details: \(err.localizedDescription)" as NSString)
                self.callErrorWithCustomMessage("Something went wrong with loading data")
            }
        })
    }
    
    
    
    
    
    
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func goToVisualization(_ sender: UIButton) {
        
    }
    
    /* Initialozas Singleton with starting data such as Campus, SiteId and other important parameters for future requests */
    func getSiteID (complete: @escaping (Bool?, Error?) -> Void){
        NetworkManager.getRequestData(isLocation: false, endpoint: "api/config/v1/sites", params: [:], method: .get, completion: { data, error in
            if let d = data {
                guard let t = try? JSONDecoder().decode([SiteID].self, from: d) else {
                    print("Error decoding json")
                    complete(false, nil)
                    return
                }
                complete(true, nil)
                Client.sharedInstance.siteID = t[0]
                
            }
            if let err = error{
                self.logError(timestamp: Int32(Date().getTimeStamp()), ErrorMsg: "Error from Initial View Controller. Error getting site ID. Details: \(err.localizedDescription)" as NSString)
                print("Error getting site ID. Details: \(err.localizedDescription)")
                complete(false, err)
            }
        })
        
    }
    
    
    func getInitialLocationData(complete: @escaping (Bool?, Error?) -> Void){
        NetworkManager.getRequestData(isLocation : true, endpoint : locationEndpoints.allFloors.rawValue, params : [:], method : .get, completion: { data, error in
            //if let error should be added
            if let d =  data{
                print("request on getting campus info completed")
                let decoder = JSONDecoder()
                guard let t = try? decoder.decode(mapJSON.self, from: d) else {
                    complete(false, nil)
                    print("error decoding json")
                    return
                }
                Client.sharedInstance.setCampus(t : t)
                complete(true, nil)
            }
            if let err = error{
                print("Error getting site ID. Details: \(err)")
                complete(false, err)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
            /*not using right now but lets leave it for now*/
        case "testVis":
            print("testVis")
        case "locationVCSegue":
            print("locationVCSegue")
        case "showForecast":
            print("showForecast")
        default:
            print("unexpected segue identifier")
        }
    }
    
    func KPIforToday(completion : @escaping (Bool, Error?) -> Void){
        NetworkManager.getRequestData(isLocation: false, endpoint: "api/presence/v1/kpisummary/today?siteId=1513804707441", params: [:], method: .get, completion: {
            data, error in
            if let d = data{
                //            print("kpisummary/today\n\n")
                //            let json = try? JSONSerialization.jsonObject(with: d, options: [])
                //            print(json ?? "serialization of json failed")
                guard let t = try? JSONDecoder().decode(kpiSummaryJSON.self, from: d) else {
                    print("error decoding json")
                    return
                }
                
                if let visitorCount = t.visitorCount {
                    self.labelsForStatistics["total"] = "Total count of visitors today: \(visitorCount)" as AnyObject
                } else {
                    self.labelsForStatistics["total"] = "Total count of visitors today ...loading..." as AnyObject
                }
                if let averageDwell = t.averageDwell  {
                    let avgDwell = String(format: "%.02f", averageDwell)
                    self.labelsForStatistics["avgDwell"] = "Average dwell time  today is \(avgDwell)%" as AnyObject
                } else {
                    self.labelsForStatistics["avgDwell"] = "Average dwell time  today is ...loading...) %" as AnyObject
                }
                if let totalConnectedCount = t.totalConnectedCount{
                    self.labelsForStatistics["totalConnected"] = "Total number of connected visitors today: \(totalConnectedCount)" as AnyObject
                } else {
                    self.labelsForStatistics["totalConnected"] = "Total number of connected visitors today: ...loading..." as AnyObject
                }
                if let totalPasserbyCount = t.totalPasserbyCount{
                    self.labelsForStatistics["totalPasserby"] = "Total number of passers-by  today: \(totalPasserbyCount)" as AnyObject
                } else {
                    self.labelsForStatistics["totalPasserby"] = "Total number of passers-by  today: ...loading..." as AnyObject
                }
                
                if let conversionRate = t.conversionRate {
                    self.labelsForStatistics["conversionRate"] = "Conversion rate is \(conversionRate) " as AnyObject
                } else {
                    self.labelsForStatistics["conversionRate"] = "Conversion rate is ...loading... " as AnyObject
                }
                if let topManufacturers = t.topManufacturers{
                    if let name = topManufacturers.name {
                        self.labelsForStatistics["topManufacturer"] = "Tope manufacturer is \(name) " as AnyObject
                    } else {
                        self.labelsForStatistics["topManufacturer"] = "Tope manufacturer is ...loading... " as AnyObject
                    }
                } else {
                    self.labelsForStatistics["topManufacturer"] = "Tope manufacturer is ...loading... " as AnyObject
                }
                if let connectedPercentage =  t.connectedPercentage {
                    let CP = String(format: "%.02f", connectedPercentage)
                    self.labelsForStatistics["connectedPercentage"] = "Connected percentage is \(CP)%" as AnyObject
                } else {
                    self.labelsForStatistics["connectedPercentage"] = "Connected percentage is ...loading..." as AnyObject
                }
                if let peakHour = t.peakSummary?.peakHour{
                    self.labelsForStatistics["peakHour"] = "Peak hour by far is \(peakHour) " as AnyObject
                } else {
                    self.labelsForStatistics["peakHour"] = "Peak hour by far is .... " as AnyObject
                }
                
                completion(true, nil)
                // t.prinAll()
            } else if let e = error {
                completion(false, e)
            }
            
        })
    }
}
