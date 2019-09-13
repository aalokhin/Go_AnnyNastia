//
//  PresenceRequests.swift
//  CCMN
//
//  Created by ANASTASIA on 9/3/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation



extension PresenceVisualizationVC {
    
    func getAllData(){
        getAllProximities()
        getAllDwellRepeatInfo()
       
    }
    func getAllDwellRepeatInfo(){
        let targets = ["repeatvisitors", "dwell"]
        for target in targets {
            getRepeatAndDwell(target, complete: {
                error in
                if error == nil{
                    self.tableView.reloadData()
                }
                if let e = error{
                    self.logError(timestamp: Int32(Date().getTimeStamp()), ErrorMsg: NSString(string: e.localizedDescription))
                }
                
            })
            getDistribution(target, complete: {
                error in
                if error == nil{
                    self.tableView.reloadData()
                }
                if let e = error{
                    self.logError(timestamp: Int32(Date().getTimeStamp()), ErrorMsg: NSString(string: e.localizedDescription))
                }
                
            })
        }
        
    }
    
    func getAllProximities(){
        if hourly == true{
            getHourlyProximity(complete: {
                error in
                if error == nil{
                    self.tableView.reloadData()
                }
                if let e = error{
                    self.logError(timestamp: Int32(Date().getTimeStamp()), ErrorMsg: NSString(string: e.localizedDescription))
                }
                
            })
        }else {
            getDailyProximity(complete: {
                error in
                if error == nil{
                    self.tableView.reloadData()
                }
                if let e = error{
                    self.logError(timestamp: Int32(Date().getTimeStamp()), ErrorMsg: NSString(string: e.localizedDescription))
                }
                
            })
        }
    }

    func getDailyProximity(complete: @escaping (Error?) -> Void){
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
                                complete(nil)
                                //self.tableView.reloadData()
                                
                            }
                            if let e = error{
                                complete(e)
                            }
                            
                        })
                    }
                    if let e = error{
                        complete(e)
                    }
                })
                
            }
        })
    }
    
    func getHourlyProximity(complete: @escaping (Error?) -> Void){
        let siteId = Client.sharedInstance.siteID?.aesUidString ?? "1513804707441"
        self.allUsersForProximity.removeAll()
        //print("api/presence/v1/connected/hourly/\(self.dateSpan)?siteId=\(siteId)")
        NetworkManager.getRequestData(isLocation: false, endpoint: "api/presence/v1/connected/hourly/\(self.dateSpan)?siteId=\(siteId)", params: [:], method: .get, completion: {
            data, error in
            if let d = data{
                let decoder = JSONDecoder()
                guard let t = try? decoder.decode([String : Int].self, from: d) else {
                    print("error decoding json")
                    return
                }
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
                                complete(nil)
                            }
                            
                        })
                        
                    }
                    
                })
            }
            
        })
    }
    
    /*.................................... Clean code. Kinda .....................................*/
    
    func getDistribution(_ dwellTarget : String, complete: @escaping (Error?) -> Void){
        let url = constructUrl(dwellTarget, count: true)
        NetworkManager.getRequestData(isLocation: false, endpoint: url, params: [:], method: .get, completion: {
            data, error in
            if let d = data{
                guard let t = try? JSONDecoder().decode([String : Int].self, from: d) else {
                    print("error decoding json")
                    return
                }
                if (dwellTarget == "dwell"){
                    self.dwellDistribution = t
                }
                else if (dwellTarget == "repeatvisitors"){
                    self.repeatDistribution = t
                }
                complete(nil)
                //self.tableView.reloadData()
            } else if let err = error{
                complete(err)
            }
        })
        
    }
    
    
    
    /* .................................    For linears     ................................. */
    func getRepeatAndDwell(_ target : String, complete: @escaping (Error?) -> Void){
        self.setAllDwellString.removeAll()
        self.setAllRepeatString.removeAll()
        
        let url = constructUrl(target, count: false) //  "api/presence/v1/\(target)/hourly/\(dateSpan)?siteId=\(siteId)" || "api/presence/v1/\(target)/daily?siteId=\(siteId)&startDate=\(self.startDate)&endDate=\(self.endDate)"
        NetworkManager.getRequestData(isLocation: false, endpoint: url, params: [:], method: .get, completion: {
            data, error in
            if let d = data{
                let decoder = JSONDecoder()
                if self.dateSpan == "3days"{//[String :[String : [String : Double]]]
                    /*...*/
                }
                else {
                    guard let t = try? decoder.decode([String : [String : Double]].self, from: d) else {
                        print("error decoding json some otehr for repeat  json")
                        return
                    }
                    if (target == "repeatvisitors"){
                        self.setAllRepeatString = self.fillSetsForLinear(t : t, strArray: self.RepeatVisitorsDwell)
                    }
                    else if (target == "dwell"){
                        self.setAllDwellString = self.fillSetsForLinear(t : t, strArray:  self.HoursDwell)
                    }
                }
                complete(nil)
            } else if let err = error{
                complete(err)
            }
            
        })
    }
    
    
    
    func fillSetsForLinear(t : [String : [String : Double]], strArray : [String])-> [String : AnyObject]{
        var finalSet = [String : AnyObject]()
        var setForDwellPeriods : [String:AnyObject] = [:]
        for one in t {
            //print(one.key)
            //print(one.value)
            if let value = t[one.key] {
                for two in strArray{
                    if let value2 = value[two] {
                        setForDwellPeriods[two] = value2 as AnyObject?
                    }
                }
                finalSet[one.key] = setForDwellPeriods as AnyObject?
            }
        }
        return finalSet
    }
    
    
    func constructUrl(_ urlTarget : String, count : Bool) -> String{
        let siteId = Client.sharedInstance.siteID?.aesUidString ?? "1513804707441"
        var url = "api/presence/v1/\(urlTarget)/"
        if count == true{
            url = url + "count"
        } else {
            if hourly == true {
                url = url + "hourly"
            } else {
                url = url + "daily"
            }
        }
        
        if (hourly == false){
            url = url + "?siteId=\(siteId)&startDate=\(self.startDate)&endDate=\(self.endDate)"
        } else {
            url = url + "/\(dateSpan)?siteId=\(siteId)"
        }
        //print(url)
        return url
        
    }
    
}
