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

class DwellTimeVis : UIViewController {
    var startDate = ""
    var endDate = ""
    var YValues : [Double] = []
    var HoursYValues : [String:Double]?
    let HoursForDic = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
    let hours = ["12am-01am", "01am-02am", "02am-03am", "03am-04am", "04am-05am",  "05am-06am", "06am-07am", "07am-08am", "08am-09am", "09am-10am", "10am-11am", "11am-12pm", "12pm-01pm", "01pm-02pm", "02pm-03pm", "03pm-04pm", "04pm-05pm", "05pm-06pm", "06pm-07pm", "07pm-08pm", "08pm-09pm", "09pm-10pm", "10pm-11pm", "11pm-12am"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        print("hi from vis vc")
        super.viewDidLoad()
        setupVC()
       // getDwell()
        getHourlyConnected()
        print("start-", startDate, "end-", endDate)
        
    }
    func setupVC() {

        
        tableView.register(UINib(nibName: ChartViewCell.nibName(), bundle: nil), forCellReuseIdentifier: ChartViewCell.reuseIdentifier())
        tableView.register(UINib(nibName: EmptyChartCell.nibName(), bundle: nil), forCellReuseIdentifier: EmptyChartCell.reuseIdentifier())

        self.tableView.rowHeight = 400.0

    }
    
    func getHourlyConnected(){
        let siteId = Client.sharedInstance.siteID?.aesUidString ?? "1513804707441"

        NetworkManager.getRequestData(isLocation: false, endpoint: "api/presence/v1/connected/hourly/yesterday?siteId=\(siteId)", params: [:], method: .get, completion: {
            data, error in
            if let d = data{
                print("connected/hourly/yesterday \n\n")
                
//                if let json = try? JSONSerialization.jsonObject(with: d, options: []){
//
//                    print(json)
//                }
                
                let decoder = JSONDecoder()
                guard let t = try? decoder.decode([String : Int].self, from: d) else {
                    print("error decoding json")
                    return
                }
                print(t)
                for one in self.HoursForDic {
                    let value = Double(t[one] ?? -1)
                    self.YValues.append(value)
                    //print(one, "==>", value)
                }
                self.tableView.reloadData()
            }
            
        })
    }
    
    func getDwell(){
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
}

