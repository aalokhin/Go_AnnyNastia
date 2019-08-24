//
//  DwellTimeExt.swift
//  CCMN
//
//  Created by ANASTASIA on 8/23/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
import UIKit

extension PresenceVisualizationVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (allUsers.count == 0){
            return 0
        } else {
            return 5
        }
    }
    //http://www.thomashanning.com/the-most-common-mistake-in-using-uitableview/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        // getHourlyConnected()
        let values = YValues
        let cell = tableView.dequeueReusableCell(withIdentifier: EmptyChartCell.reuseIdentifier()) as! EmptyChartCell
        
        if indexPath.row == 1{
            for v in cell.subviews{
                v.removeFromSuperview()
            }
            cell.createLinearChart(dataPoints: hours, values: values)
        } else if indexPath.row == 2{
            for v in cell.subviews{
                v.removeFromSuperview()
            }
            cell.createPieChart(dataPoints: hours, values: values)
        } else {
            for v in cell.subviews{
                v.removeFromSuperview()
            }
            cell.createGroupedBarChart(dataPoints: hours, values: allUsers)
        }
        return cell
        
    }
    
    //https://medium.com/@felicity.johnson.mail/lets-make-some-charts-ios-charts-5b8e42c20bc9
    
    
    
    
}

