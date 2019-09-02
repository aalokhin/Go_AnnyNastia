//
//  DwellTimeVis.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 8/14/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.

//                if let json = try? JSONSerialization.jsonObject(with: d, options: []){
//                    print(json)
//
//                }
//https://medium.com/@stasost/ios-how-to-build-a-table-view-with-multiple-cell-types-2df91a206429

import Foundation
import UIKit
import Charts

class PresenceVisualizationVC : UIViewController {
    
    
    var startDate : String = Date().toStringDefault()
    var endDate : String =  Date().toStringDefault()
    var hourly : Bool = true
    var dateSpan : String = "today"
    
    
    var dailyProximity = SDailyProximity()
    
    struct SDailyProximity {
        var datapoints : [String] = []
        var values : [[Double]] = []
    }
    
    
    
    var YValues : [Double] = []
    var allUsersForProximity : [[Double]] = []
    
    
    var setAllDwell : [Int:AnyObject] = [:]
    var setAllRepeat = [Int : AnyObject]()
    
    var repeatDistribution : [String : Int] = [:]
    var dwellDistribution : [String : Int] = [:]
    
    let HoursForDicInt : [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]
    let hours = ["12am-01am", "01am-02am", "02am-03am", "03am-04am", "04am-05am",  "05am-06am", "06am-07am", "07am-08am", "08am-09am", "09am-10am", "10am-11am", "11am-12pm", "12pm-01pm", "01pm-02pm", "02pm-03pm", "03pm-04pm", "04pm-05pm", "05pm-06pm", "06pm-07pm", "07pm-08pm", "08pm-09pm", "09pm-10pm", "10pm-11pm", "11pm-12am"]
    let HoursDwell = ["FIVE_TO_THIRTY_MINUTES", "ONE_TO_FIVE_HOURS", "EIGHT_PLUS_HOURS", "FIVE_TO_EIGHT_HOURS", "THIRTY_TO_SIXTY_MINUTES"]
    let RepeatVisitorsDwell = ["DAILY", "FIRST_TIME", "OCCASIONAL", "WEEKLY", "YESTERDAY"]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidAppear(_ animated: Bool) {
        
        getDailyProximity()
        //////////////////
        getRepeatDistribution()
        
        getDwellTimeDistribution()
        
        
        
        getHourlyProximityUsers()
    }
    
    override func viewDidLoad() {
        print("hi from vis vc")
        super.viewDidLoad()
        setupVC()
        //getDailyProximity()
        
        
        ////////////////////////////
        getAllData()
    }
    
    
    func getAllData(){
        getHourlyProximityUsers()
        getDwellTime()
        getRepeatVis()
        getRepeatDistribution()
        
    }
    
   
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
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
                var setForDwellPeriods : [String:AnyObject] = [:]
                for one in self.HoursForDicInt {
                    if let value = t[one]{
                        for two in self.HoursDwell{
                            if let value2 = value[two]
                            {
                                setForDwellPeriods[two] = value2 as AnyObject?
                            }
                        }
                        self.setAllDwell[one] = setForDwellPeriods as AnyObject?
                    }
                }
                self.tableView.reloadData()
                
            }
            
        })
    }
    
    
    
    
    //visitor
    
    
    
    func getHourlyProximityUsers(){
        let siteId = Client.sharedInstance.siteID?.aesUidString ?? "1513804707441"
         self.allUsersForProximity.removeAll()
        print("api/presence/v1/connected/hourly/\(self.dateSpan)?siteId=\(siteId)")
        NetworkManager.getRequestData(isLocation: false, endpoint: "api/presence/v1/connected/hourly/\(self.dateSpan)?siteId=\(siteId)", params: [:], method: .get, completion: {
            data, error in
            if let d = data{
                let decoder = JSONDecoder()
                guard let t = try? decoder.decode([String : Int].self, from: d) else {
                    print("error decoding json")
                    return
                }
                // print(t)
                let HoursForDic = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
                
                var firstSet : [Double] = []
                for one in HoursForDic {
                    if let value = t[one]{
                        firstSet.append(Double(value))
                    }
                }
                self.allUsersForProximity.append(firstSet)
                
                NetworkManager.getRequestData(isLocation: false, endpoint: "api/presence/v1/visitor/hourly/\(self.dateSpan)?siteId=\(siteId)", params: [:], method: .get, completion: {
                    data, error in
                    if let d = data{
                        let decoder = JSONDecoder()
                        guard let t = try? decoder.decode([String : Int].self, from: d) else {
                            print("error decoding json")
                            return
                        }
                        //print(t)
                        var secondSet : [Double] = []
                        for one in HoursForDic {
                            if let value = t[one]{
                                secondSet.append(Double(value))
                            }
                        }
                        self.allUsersForProximity.append(secondSet)
                        NetworkManager.getRequestData(isLocation: false, endpoint: "api/presence/v1/passerby/hourly/\(self.dateSpan)?siteId=\(siteId)", params: [:], method: .get, completion: {
                            data, error in
                            if let d = data{
                                let decoder = JSONDecoder()
                                guard let t = try? decoder.decode([String : Int].self, from: d) else {
                                    print("error decoding json")
                                    return
                                }
                                //print(t)
                                var thirdSet: [Double] = []
                                for one in HoursForDic {
                                    if let value = t[one]{
                                        thirdSet.append(Double(value))
                                    }
                                }
                                self.allUsersForProximity.append(thirdSet)
                                
                            }
                            
                        })
                        
                    }
                    
                })
            }
            
        })
    }
    
    /////////////////////////////////////////////////////////////////////////////////////
    
    func getKPI(){
        NetworkManager.getRequestData(isLocation: false, endpoint: "api/presence/v1/kpisummary?siteId=1513804707441&startDate=\(startDate)&endDate=\(endDate)", params: [:], method: .get, completion: {
            data, error in
            if let d = data{
                print("kpisummary/today\n\n")
                
                //                if let json = try? JSONSerialization.jsonObject(with: d, options: []){
                //                   // print(json)
                //                }
                let decoder = JSONDecoder()
                guard let t = try? decoder.decode(kpiSummaryJSON.self, from: d) else {
                    print("error decoding json")
                    return
                }
                t.prinAll()
                
            }
            
        })
        
    }
    
    func reqWithParams(){
        if let siteId = Client.sharedInstance.siteID?.aesUId {
            NetworkManager.getRequestData(isLocation: false, endpoint: "api/presence/v1/connected/hourly/3days?siteId=\(siteId)", params: [:], method: .get, completion: {
                data, error in
                if let d = data{
                    print("connected/hourly/yesterday \n\n")
                    
                    //
                    //                        //print(json)
                    //                    }
                }
            })
        }
        
    }
    
    
    
    
    func setupVC() {
        tableView.register(UINib(nibName: EmptyChartCell.nibName(), bundle: nil), forCellReuseIdentifier: EmptyChartCell.reuseIdentifier())
        self.tableView.rowHeight = 400.0
        let setUpButton = UIBarButtonItem(title: "SetUp", style: .done, target: self, action: #selector(setUpPeriod))
        self.navigationItem.rightBarButtonItem  = setUpButton
        
    }
    
    @objc func setUpPeriod(){
        print("setUpPeriod clicked")
        let storyboard = UIStoryboard.init(name: "SearchSetUpVC", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier : "SearchSetUpVC") as! SearchSetUpVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    func getRepeatVis(){
        print("Let's get repeat visitors")
        
        let siteId = Client.sharedInstance.siteID?.aesUidString ?? "1513804707441"
        NetworkManager.getRequestData(isLocation: false, endpoint: "api/presence/v1/repeatvisitors/hourly/yesterday?siteId=\(siteId)", params: [:], method: .get, completion: {
            data, error in
            if let d = data{
                let decoder = JSONDecoder()
                guard let t = try? decoder.decode([Int : [String : Double]].self, from: d) else {
                    print("error decoding json")
                    return
                }
                //print(t)
                var setForDwellRepeat : [String:AnyObject] = [:]
                for one in self.HoursForDicInt {
                    if let value = t[one]{
                        // print(one, ">>>")
                        for two in self.RepeatVisitorsDwell{
                            if let value2 = value[two]
                            {
                                setForDwellRepeat[two] = value2 as AnyObject?
                            }
                        }
                        self.setAllRepeat[one] = setForDwellRepeat as AnyObject?
                    }
                }
                self.tableView.reloadData()
                //print("------------------------\(self.setAllRepeat)-----------------------------")
            }
            
        })
    }
    
  
    
    
////////////////////////////////////////// adaptive already //////////////////////////////////////////////////////////////////
    
    func getDwellTimeDistribution(){
        let siteId = Client.sharedInstance.siteID?.aesUidString ?? "1513804707441" //"api/presence/v1/repeatvisitors/count/yesterday?siteId=\(siteId)"

        var url : String = ""
        if (hourly == false){
            url = "api/presence/v1/dwell/count?siteId=\(siteId)&startDate=\(self.startDate)&endDate=\(self.endDate)"
        } else {
            print("lalallalal adaptive dwell")
            url = "api/presence/v1/dwell/count/\(dateSpan)?siteId=\(siteId)"
        }
        NetworkManager.getRequestData(isLocation: false, endpoint: url, params: [:], method: .get, completion: {
            data, error in
            if let d = data{
                guard let t = try? JSONDecoder().decode([String : Int].self, from: d) else {
                    print("error decoding json")
                    return
                }
                self.dwellDistribution = t
                self.tableView.reloadData()
            }
            
        })
        
    }
    
    func getRepeatDistribution(){
        let siteId = Client.sharedInstance.siteID?.aesUidString ?? "1513804707441" //"api/presence/v1/repeatvisitors/count/yesterday?siteId=\(siteId)"
        var url : String = ""
        if (hourly == false){
            url = "api/presence/v1/repeatvisitors/count?siteId=\(siteId)&startDate=\(self.startDate)&endDate=\(self.endDate)"
        } else {
            print("lalallalal adaptive dwell")
            url = "api/presence/v1/repeatvisitors/count/\(dateSpan)?siteId=\(siteId)"
        }
        NetworkManager.getRequestData(isLocation: false, endpoint: url, params: [:], method: .get, completion: {
            data, error in
            if let d = data{
                guard let t = try? JSONDecoder().decode([String : Int].self, from: d) else {
                    print("error decoding json")
                    return
                }
                self.repeatDistribution = t
                self.tableView.reloadData()
            }
            
        })
        
    }
    
    func getDailyProximity(){
        dailyProximity.datapoints.removeAll()
        dailyProximity.values.removeAll()
        let siteId = Client.sharedInstance.siteID?.aesUidString ?? "1513804707441"
        NetworkManager.getRequestData(isLocation: false, endpoint: "api/presence/v1/connected/daily?siteId=\(siteId)&startDate=\(self.startDate)&endDate=\(self.endDate)", params: [:], method: .get, completion: {
            data, error in
            if let d = data{
                let decoder = JSONDecoder()
                guard let t = try? decoder.decode([String : Int].self, from: d) else {
                    print("error decoding json")
                    return
                }
                
                var userNbrDataSet : [Double] = []
                for one in t {
                    self.dailyProximity.datapoints.append(one.key) //appending datapoints once
                    userNbrDataSet.append(Double(one.value))
                }
                self.dailyProximity.values.append(userNbrDataSet)
                
                NetworkManager.getRequestData(isLocation: false, endpoint: "api/presence/v1/visitor/daily?siteId=\(siteId)&startDate=\(self.startDate)&endDate=\(self.endDate)", params: [:], method: .get, completion: {
                    data, error in
                    if let d = data{
                        guard let t = try? decoder.decode([String : Int].self, from: d) else {
                            print("error decoding json")
                            return
                        }
                        userNbrDataSet.removeAll() //clearing data to use the variable to collect new data
                        for one in t {
                            userNbrDataSet.append(Double(one.value))
                        }
                        self.dailyProximity.values.append(userNbrDataSet)
                        NetworkManager.getRequestData(isLocation: false, endpoint: "api/presence/v1/passerby/daily?siteId=\(siteId)&startDate=\(self.startDate)&endDate=\(self.endDate)", params: [:], method: .get, completion: {
                            data, error in
                            if let d = data{
                                guard let t = try? decoder.decode([String : Int].self, from: d) else {
                                    print("error decoding json")
                                    return
                                }
                                userNbrDataSet.removeAll() //clearing data to use the variable to collect new data
                                for one in t {
                                    userNbrDataSet.append(Double(one.value))
                                }
                                self.dailyProximity.values.append(userNbrDataSet)
                                self.tableView.reloadData()
                                for one in self.dailyProximity.datapoints{
                                   // print(one)
                                    let arr = ["conn", "repeat", "passerby"]
                                    for i in 0..<self.dailyProximity.values.count{
                                        print(arr[i], ">>>>", self.dailyProximity.values[i])
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        })
                    }
                })
                
            }
        })
    }
    
}

