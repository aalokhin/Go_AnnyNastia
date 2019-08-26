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
        if (repeatDistribution.count == 0 || setAllRepeat.count == 0 || allUsers.count == 0 || setAllDwell.count == 0){
            return 0
        } else {
            return 5
        }
        
    }
    //http://www.thomashanning.com/the-most-common-mistake-in-using-uitableview/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        // getHourlyConnected()
       
        let cell = tableView.dequeueReusableCell(withIdentifier: EmptyChartCell.reuseIdentifier()) as! EmptyChartCell
        if indexPath.row == 0{
            for v in cell.subviews{
                v.removeFromSuperview()
            }
            cell.createLinearChart(hours: hours, allDwell: setAllRepeat.sorted(by: { $0.key < $1.key }), timeLabels: RepeatVisitorsDwell, addGradient: false)
        } else if indexPath.row == 1{
            for v in cell.subviews{
                v.removeFromSuperview()
            }
            
            cell.createLinearChart(hours: hours, allDwell: setAllDwell.sorted(by: { $0.key < $1.key }), timeLabels: HoursDwell, addGradient: true)
        } else if indexPath.row == 2 {
            for v in cell.subviews{
                v.removeFromSuperview()
            }
            var dataPoints : [String] = []
            var values : [Double] = []
            for one in repeatDistribution{
                if one.key == "YESTERDAY"{
                    continue
                }
                dataPoints.append(one.key)
                values.append(Double(one.value))
            }
            cell.createPieChart(dataPoints: dataPoints, values: values, chartName: "Repeat visitors Distribution")
            
        } else if indexPath.row == 4 {
            for v in cell.subviews{
                v.removeFromSuperview()
            }
            var dataPoints : [String] = []
            var values : [Double] = []
            for one in dwellDistribution{
                dataPoints.append(one.key)
                values.append(Double(one.value))
            }
            cell.createPieChart(dataPoints: dataPoints, values: values, chartName : "Dwell Time Distribution")
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

extension PresenceVisualizationVC : SetUpDelegate {
    func specifyDates(from: Date, to: Date, detailed : Bool) {
        self.startDate = from.toStringDefault()
        self.endDate = to.toStringDefault()
        print("hey from delegat here are our dates \(from) and \(to)")
    }
    
    
}


