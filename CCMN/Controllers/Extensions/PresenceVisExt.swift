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
        if (dailyProximity.datapoints.count == 0 || dailyProximity.values.count == 0 || repeatDistribution.count == 0 || setAllRepeat.count == 0 || allUsersForProximity.count == 0 || setAllDwell.count == 0){
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
            cell.createLinearChart(datapoints: hours, allDwell: setAllRepeat.sorted(by: { $0.key < $1.key }), timeLabels: RepeatVisitorsDwell, addGradient: false)
        } else if indexPath.row == 1{
            for v in cell.subviews{
                v.removeFromSuperview()
            }

            cell.createLinearChart(datapoints: hours, allDwell: setAllDwell.sorted(by: { $0.key < $1.key }), timeLabels: HoursDwell, addGradient: true)
            
            
            ///////////////////////////////////is okay/////////////////////////////
        } else if indexPath.row == 2 {
            for v in cell.subviews{
                v.removeFromSuperview()
            }
            var dataPoints : [String] = []
            var values : [Double] = []
            let sorted = repeatDistribution.sorted(by: { $0.value < $1.value })
            for one in sorted {
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
            let sorted = dwellDistribution.sorted(by: { $0.value < $1.value })
            for one in sorted{
                dataPoints.append(one.key)
                values.append(Double(one.value))
            }
            cell.createPieChart(dataPoints: dataPoints, values: values, chartName : "Dwell Time Distribution")
        } else {
            for v in cell.subviews{
                v.removeFromSuperview()
            }
             // /////////////////// PROXIMITY //////////////////////////////////////
            if (hourly == true)
            {
                cell.createGroupedBarChart(dataPoints: hours, values: allUsersForProximity)
            } else {
                cell.createGroupedBarChart(dataPoints: dailyProximity.datapoints, values: dailyProximity.values)
            }
        }
        return cell
        
    }
    //https://medium.com/@felicity.johnson.mail/lets-make-some-charts-ios-charts-5b8e42c20bc9
}

extension PresenceVisualizationVC : SetUpDelegate {
    func specifyDates(from: Date, to: Date, hourly : Bool, dateSpan : String?) {
        self.startDate = from.toStringDefault()
        self.endDate = to.toStringDefault()
        self.hourly = hourly
        self.dateSpan = dateSpan ?? "today"
        print("hey from delegat here are our dates \(from) and \(to), hourly \(hourly), span \(dateSpan ?? "no date span")")
    }
    
    
}


