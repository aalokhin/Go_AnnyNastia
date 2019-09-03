//
//  PresenceRequests.swift
//  CCMN
//
//  Created by ANASTASIA on 9/3/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation



extension PresenceVisualizationVC {
    func getDwellTimeDistribution(){
        let siteId = Client.sharedInstance.siteID?.aesUidString ?? "1513804707441" //"api/presence/v1/repeatvisitors/count/yesterday?siteId=\(siteId)"
        
        var url : String = ""
        if (hourly == false){
            url = "api/presence/v1/dwell/count?siteId=\(siteId)&startDate=\(self.startDate)&endDate=\(self.endDate)"
        } else {
            //print("lalallalal adaptive dwell")
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
            //print("lalallalal adaptive dwell")
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
                                    //                                    for i in 0..<self.dailyProximity.values.count{
                                    //                                        print(arr[i], ">>>>", self.dailyProximity.values[i])
                                    //
                                    //                                    }
                                    
                                }
                                
                            }
                            
                        })
                    }
                })
                
            }
        })
    }
    
    func getHourlyProximityUsers(){
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
}
