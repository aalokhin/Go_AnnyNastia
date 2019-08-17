//
//  DwellTimeVis.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 8/14/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
import UIKit
import Charts

class DwellTimeVis : UIViewController {
    var startDate = ""
    var endDate = ""
    
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
        self.tableView.rowHeight = 300.0

    }
    
    func getHourlyConnected(){
        let siteId = Client.sharedInstance.siteID?.aesUidString ?? "1513804707441"

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

extension DwellTimeVis : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    //       let hours = ["12am-01am", "01am-02am", "02am-03am", "03am-04am", "04am-05am",  "05am-06am", "06am-07am", "07am-08am", "08am-09am", "09am-10am", "10am-11am", "11am-12pm", "12pm-01pm", "01pm-02pm", "02pm-03pm", "03pm-04pm", "04pm-05pm", "05pm-06pm", "06pm-07pm", "07pm-08pm", "08pm-09pm", "09pm-10pm", "10pm-11pm", "11pm-12am"]
    //        let values = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0, 20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hours = ["12am-01am", "01am-02am", "02am-03am", "03am-04am", "04am-05am",  "05am-06am", "06am-07am", "07am-08am", "08am-09am", "09am-10am", "10am-11am", "11am-12pm", "12pm-01pm", "01pm-02pm", "02pm-03pm", "03pm-04pm", "04pm-05pm", "05pm-06pm", "06pm-07pm", "07pm-08pm", "08pm-09pm", "09pm-10pm", "10pm-11pm", "11pm-12am"]
        
        let values = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0, 20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]

        let cell = tableView.dequeueReusableCell(withIdentifier: ChartViewCell.reuseIdentifier()) as! ChartViewCell
        cell.setChart(dataPoints: hours, values: values)
        return cell
    }
    
    
}


