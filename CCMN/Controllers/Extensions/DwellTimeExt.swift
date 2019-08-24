//
//  DwellTimeExt.swift
//  CCMN
//
//  Created by ANASTASIA on 8/23/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
import UIKit

extension DwellTimeVis : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (allUsers.count == 0){
            return 0
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        // getHourlyConnected()
        let values = YValues
        //let values = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0, 20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyChartCell.reuseIdentifier()) as! EmptyChartCell
            cell.createLinearChart(dataPoints: hours, values: values)
            return cell
        } else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyChartCell.reuseIdentifier()) as! EmptyChartCell
            cell.createPieChart(dataPoints: hours, values: values)
            return cell
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: EmptyChartCell.reuseIdentifier()) as! EmptyChartCell
        cell.createGroupedBarChart(dataPoints: hours, values: allUsers)
        return cell
        
    }
    
    //https://medium.com/@felicity.johnson.mail/lets-make-some-charts-ios-charts-5b8e42c20bc9
    
    
    
    
}

