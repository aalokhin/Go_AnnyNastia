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
    
    var numberOfSections = 5
    
    
    var startDate : String = Date().toStringDefault()
    var endDate : String =  Date().toStringDefault()
    var hourly : Bool = true
    var dateSpan : String = "today"
    var dailyProximity = SDailyProximity()
    struct SDailyProximity {
        var datapoints : [String] = []
        var values : [[Double]] = []
    }
    var allUsersForProximity : [[Double]] = []
    
    var setAllDwellString = [String : AnyObject]()
    var setAllRepeatString = [String : AnyObject]()
    
    var repeatDistribution : [String : Int] = [:]
    var dwellDistribution : [String : Int] = [:]
    
    let HoursForDicInt : [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]
    let hours = ["00", "01-02", "02-03", "03-04", "04-05",  "05-06", "06-07", "07-08", "08-09", "09-10", "10-11", "11-12", "12-13", "13-14", "14-15", "15-16", "16-17", "17-18", "18-19", "19-20", "20-21", "21-22", "22-23", "23-00"]
    let HoursDwell = ["FIVE_TO_THIRTY_MINUTES", "ONE_TO_FIVE_HOURS", "EIGHT_PLUS_HOURS", "FIVE_TO_EIGHT_HOURS", "THIRTY_TO_SIXTY_MINUTES"]
    let RepeatVisitorsDwell = ["DAILY", "FIRST_TIME", "OCCASIONAL", "WEEKLY", "YESTERDAY"]
    
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        print("hi from vis vc")
        super.viewDidLoad()
        setupVC()
        getAllData()
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
    
    
//    func getKPI(){
//        NetworkManager.getRequestData(isLocation: false, endpoint: "api/presence/v1/kpisummary?siteId=1513804707441&startDate=\(startDate)&endDate=\(endDate)", params: [:], method: .get, completion: {
//            data, error in
//            if let d = data{
//                print("kpisummary/today\n\n")
//                let decoder = JSONDecoder()
//                guard let t = try? decoder.decode(kpiSummaryJSON.self, from: d) else {
//                    print("error decoding json")
//                    return
//                }
//               // t.prinAll()
//                
//            }
//            
//        })
//        
//    }
}

