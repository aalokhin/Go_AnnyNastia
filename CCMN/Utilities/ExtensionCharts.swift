//
//  ExtensionCharts.swift
//  CCMN
//
//  Created by ANASTASIA on 9/7/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
import Charts

extension BarChartView {
    func designBarChart(dataPoints: [String]){
        let legend = self.legend
        legend.enabled = true
        legend.verticalAlignment = .top
        
        self.xAxis.labelFont = UIFont.systemFont(ofSize: 9)
        let xaxis = self.xAxis
        xaxis.drawGridLinesEnabled = true
        xaxis.labelPosition = .bottom
        xaxis.valueFormatter = IndexAxisValueFormatter(values : dataPoints)
        xaxis.avoidFirstLastClippingEnabled = true
        xaxis.labelCount = 12 //dataPoints.count
        self.leftAxis.axisMinimum = 0.0
        self.xAxis.granularity = 1
        xAxis.avoidFirstLastClippingEnabled = false
        //self.axisMinimum = 0.0
        //xaxis.labelRotationAngle = -45
        self.rightAxis.drawLabelsEnabled = false
        self.rightAxis.enabled = false
        self.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        self.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
    }
    
    func fillDatasets(dataPoints: [String], values: [[Double]]){
        print(">>>>>>>>>", dataPoints)
        var dataEntryArr : [[BarChartDataEntry]] = []
        for one in 0..<values.count{
            var dataEntries: [BarChartDataEntry] = []
            for i in 0..<values[one].count {
                let dataEntry = BarChartDataEntry(x: Double(i), y: values[one][i])
                dataEntries.append(dataEntry)
            }
            dataEntryArr.append(dataEntries)
        }
        var dataSets : [BarChartDataSet] = []
        let labels = ["Connected", "Passerby", "Visitor"]
        for i in 0..<dataEntryArr.count{
            let set = BarChartDataSet(entries: dataEntryArr[i], label: labels[i])
            set.valueTextColor = UIColor.clear

            dataSets.append(set)
        }
        for i in 0..<dataSets.count{
            dataSets[i].colors = [getColor(int: i)]
        }
        
        let chartData = BarChartData(dataSets: dataSets)
        self.data = chartData
        let groupSpace = 0.6
        let barSpace = 0.05
        let barWidth = 0.3
        // (0.3 + 0.05) * 2 + 0.3 = 1.00 -> interval per "group"
        
        let groupCount = values[0].count
        let startYear = 0
        chartData.barWidth = barWidth
        self.xAxis.drawLabelsEnabled = false
        self.xAxis.axisMinimum = Double(startYear)
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        self.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
        
        chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
        self.xAxis.drawLabelsEnabled = false
        self.notifyDataSetChanged()
    }
    
    func getColor(int : Int) -> UIColor {
        switch int {
        case 0:
            return UIColor(hue: 0.9194, saturation: 0.92, brightness: 0.98, alpha: 1.0) /* #fc1488 */
        case 1:
            return UIColor(hue: 0.475, saturation: 0.92, brightness: 0.94, alpha: 1.0) /* #13efce */
        case 2:
            return UIColor(hue: 0.2, saturation: 0.92, brightness: 1, alpha: 1.0) /* #d0ff14 */
        case 3:
            return UIColor(red: 0.7843, green: 0.7843, blue: 0.7843, alpha: 1.0) /* #c8c8c8 */
        case 4:
            return UIColor(hue: 0.0778, saturation: 1, brightness: 0.94, alpha: 1.0) /* #ef6f00 */
        case 5:
            return UIColor(hue: 0.9333, saturation: 1, brightness: 0.66, alpha: 1.0) /* #a80043 */
        default:
            return UIColor(red: 1, green: 0.0784, blue: 0.5765, alpha: 1.0) /* #ff1493 */
        }
    }
    
}


    


