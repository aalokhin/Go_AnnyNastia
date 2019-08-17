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
        getDwell()
        print("start-", startDate, "end-", endDate)
        
    }
    func setupVC() {

        
        tableView.register(UINib(nibName: ChartViewCell.nibName(), bundle: nil), forCellReuseIdentifier: ChartViewCell.reuseIdentifier())
        self.tableView.rowHeight = 300.0

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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChartViewCell.reuseIdentifier()) as! ChartViewCell
        return cell
    }
    
    
}
