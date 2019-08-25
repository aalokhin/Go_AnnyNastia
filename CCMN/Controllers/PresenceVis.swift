//
//  DwellTimeVis.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 8/14/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//https://medium.com/@stasost/ios-how-to-build-a-table-view-with-multiple-cell-types-2df91a206429

import Foundation
import UIKit
import Charts

class PresenceVisualizationVC : UIViewController {
    var startDate = ""
    var endDate = ""
    var YValues : [Double] = []
    var allUsers : [[Double]] = []
    var setAllDwell : [Int:AnyObject] = [:]

    var HoursYValues : [String:Double]?
    let HoursForDic = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
    let HoursForDicInt : [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]
    let hours = ["12am-01am", "01am-02am", "02am-03am", "03am-04am", "04am-05am",  "05am-06am", "06am-07am", "07am-08am", "08am-09am", "09am-10am", "10am-11am", "11am-12pm", "12pm-01pm", "01pm-02pm", "02pm-03pm", "03pm-04pm", "04pm-05pm", "05pm-06pm", "06pm-07pm", "07pm-08pm", "08pm-09pm", "09pm-10pm", "10pm-11pm", "11pm-12am"]
    let HoursDwell = ["FIVE_TO_THIRTY_MINUTES", "ONE_TO_FIVE_HOURS", "EIGHT_PLUS_HOURS", "FIVE_TO_EIGHT_HOURS", "THIRTY_TO_SIXTY_MINUTES"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
        
    }
    override func viewDidLoad() {
        print("hi from vis vc")
        
        super.viewDidLoad()
        
        setupVC()
       getProximityUsers()
        getDwellTime()
        print("start-", startDate, "end-", endDate)
        
        
    }
    func getDwellTime(){
        let siteId = Client.sharedInstance.siteID?.aesUidString ?? "1513804707441"
        NetworkManager.getRequestData(isLocation: false, endpoint: "api/presence/v1/dwell/hourly/yesterday?siteId=\(siteId)", params: [:], method: .get, completion: {
            data, error in
            if let d = data{
                //                if let json = try? JSONSerialization.jsonObject(with: d, options: []){
                //                    print(json)
                //
                //                }
                
                
                let decoder = JSONDecoder()
                guard let t = try? decoder.decode([Int : [String : Double]].self, from: d) else {
                    print("error decoding json")
                    return
                }
                print(t)
                var setForDwellPeriods : [String:AnyObject] = [:]
                // var firstSet = [String : [String : Double]]()
                for one in self.HoursForDicInt {
                    if let value = t[one]{
                       // print(one, ">>>")
                        for two in self.HoursDwell{
                            if let value2 = value[two]
                            {
                                setForDwellPeriods[two] = value2 as AnyObject?
                                //print(two, value2)
                            }
                        }
                       // print(setForDwellPeriods)
                        self.setAllDwell[one] = setForDwellPeriods as AnyObject?
                    }
                }
                // print("-----------------------------------------------------")
               // print(self.setAllDwell, self.setAllDwell.keys.count)
                
                let dictValInc = self.setAllDwell.sorted(by: { $0.key < $1.key })
                //print(dictValInc)
                print("-----------------------------------------------------")
            }
            
        })
    }
    
    func reqWithParams(){
        if let siteId = Client.sharedInstance.siteID?.aesUId {
            NetworkManager.getRequestData(isLocation: false, endpoint: "api/presence/v1/connected/hourly/yesterday?siteId=\(siteId)", params: [:], method: .get, completion: {
                data, error in
                if let d = data{
                    print("connected/hourly/yesterday \n\n")
                    
                    if let json = try? JSONSerialization.jsonObject(with: d, options: []){
                        
                        print(json)
                    }
                }
            })
        }
        
    }
    
    func setupVC() {
        tableView.register(UINib(nibName: EmptyChartCell.nibName(), bundle: nil), forCellReuseIdentifier: EmptyChartCell.reuseIdentifier())
        self.tableView.rowHeight = 400.0
        
    }
    
    func getKPI(){
        NetworkManager.getRequestData(isLocation: false, endpoint: "api/presence/v1/kpisummary?siteId=1513804707441&startDate=\(startDate)&endDate=\(endDate)", params: [:], method: .get, completion: {
            data, error in
            if let d = data{
                print("kpisummary/today\n\n")
                
                if let json = try? JSONSerialization.jsonObject(with: d, options: []){
                    print(json)
                }
                let decoder = JSONDecoder()
                guard let t = try? decoder.decode(kpiSummaryJSON.self, from: d) else {
                    print("error decoding json")
                    return
                }
                t.prinAll()
                
            }
            
        })
        
    }
    //visitor
    
    
    func getProximityUsers(){
        let siteId = Client.sharedInstance.siteID?.aesUidString ?? "1513804707441"
        NetworkManager.getRequestData(isLocation: false, endpoint: "api/presence/v1/connected/hourly/yesterday?siteId=\(siteId)", params: [:], method: .get, completion: {
            data, error in
            if let d = data{
                let decoder = JSONDecoder()
                guard let t = try? decoder.decode([String : Int].self, from: d) else {
                    print("error decoding json")
                    return
                }
                print(t)
                var firstSet : [Double] = []
                for one in self.HoursForDic {
                    if let value = t[one]{
                        firstSet.append(Double(value))
                    }
                }
                self.allUsers.append(firstSet)
                NetworkManager.getRequestData(isLocation: false, endpoint: "api/presence/v1/visitor/hourly/yesterday?siteId=\(siteId)", params: [:], method: .get, completion: {
                    data, error in
                    if let d = data{
                        let decoder = JSONDecoder()
                        guard let t = try? decoder.decode([String : Int].self, from: d) else {
                            print("error decoding json")
                            return
                        }
                        print(t)
                        var secondSet : [Double] = []
                        for one in self.HoursForDic {
                            if let value = t[one]{
                                secondSet.append(Double(value))
                            }
                        }
                        self.allUsers.append(secondSet)
                        NetworkManager.getRequestData(isLocation: false, endpoint: "api/presence/v1/passerby/hourly/yesterday?siteId=\(siteId)", params: [:], method: .get, completion: {
                            data, error in
                            if let d = data{
                                let decoder = JSONDecoder()
                                guard let t = try? decoder.decode([String : Int].self, from: d) else {
                                    print("error decoding json")
                                    return
                                }
                                print(t)
                                var thirdSet: [Double] = []
                                for one in self.HoursForDic {
                                    if let value = t[one]{
                                        thirdSet.append(Double(value))
                                    }
                                }
                                self.allUsers.append(thirdSet)

                            }
                            
                        })
                        
                    }
                    
                })
            }
            
        })
    }
    
    
}

