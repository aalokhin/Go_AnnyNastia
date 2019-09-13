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
        return numberOfSections
    }
    
    //http://www.thomashanning.com/the-most-common-mistake-in-using-uitableview/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // getHourlyConnected()
        let cell = tableView.dequeueReusableCell(withIdentifier: EmptyChartCell.reuseIdentifier()) as! EmptyChartCell
  
        if indexPath.row == 0{
            for v in cell.subviews{
                v.removeFromSuperview()
            }
            
            var datapoints : [String] = []
            
            var allRepeatSort = [(key: String, value: AnyObject)]()
            if hourly == true{
                datapoints = setAllRepeatString.keys.sorted(by: { $0.toInt() < $1.toInt() })
                //print("datapoints >>>>>>>>>>>>", datapoints)
                allRepeatSort = setAllRepeatString.sorted(by: { $0.key.toInt() < $1.key.toInt() })
            } else {
               // print(setAllRepeatString)
                //print("KEYS +++> ", setAllRepeatString.keys, "hourly true? ", hourly)
                datapoints = setAllRepeatString.keys.sorted(by: { $0.toDateCustom(format: "yyyy-MM-dd")! < $1.toDateCustom(format: "yyyy-MM-dd")! })
                allRepeatSort = setAllRepeatString.sorted(by: { $0.key.toDateCustom(format: "yyyy-MM-dd")! < $1.key.toDateCustom(format: "yyyy-MM-dd")! })
            }
            
            cell.createLinearChartString(datapoints: datapoints, allDwell: allRepeatSort, timeSpanLabels: RepeatVisitorsDwell, addGradient: false)
            
            
            
            /*
            cell.createLinearChart(datapoints: hours, allDwell: allDwellSort, timeSpanLabels: RepeatVisitorsDwell, addGradient: false)
 */
            
        } else if indexPath.row == 1{
            for v in cell.subviews{
                v.removeFromSuperview()
            }
            var datapoints : [String] = []
            var allDwellSort = [(key: String, value: AnyObject)]()
            if hourly == true{
                datapoints = setAllDwellString.keys.sorted(by: { $0.toInt() < $1.toInt() })
               // print("dwell count", setAllDwellString.count)
                //print("datapoints >>>>>>>>>>>>", datapoints)
                allDwellSort = setAllDwellString.sorted(by: { $0.key.toInt() < $1.key.toInt() })
            } else {
                datapoints = setAllDwellString.keys.sorted(by: { $0.toDateCustom(format: "yyyy-MM-dd")! < $1.toDateCustom(format: "yyyy-MM-dd")! })
                allDwellSort = setAllDwellString.sorted(by: { $0.key.toDateCustom(format: "yyyy-MM-dd")! < $1.key.toDateCustom(format: "yyyy-MM-dd")! })
            }

            cell.createLinearChartString(datapoints: datapoints, allDwell: allDwellSort, timeSpanLabels: HoursDwell, addGradient: true)
/*
            cell.createLinearChart(datapoints: hours, allDwell: setAllDwell.sorted(by: { $0.key < $1.key }), timeSpanLabels: HoursDwell, addGradient: true)
 
 */
            
            
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
            //////////////////// dwellDistribution
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
        getAllData()

    }
    
    
}


