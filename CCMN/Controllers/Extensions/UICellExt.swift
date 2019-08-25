//
//  UICellExt.swift
//  CCMN
//
//  Created by ANASTASIA on 8/23/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
import UIKit
import Charts
//https://stackoverflow.com/questions/35294076/how-to-make-a-grouped-barchart-with-ios-charts
extension UITableViewCell{
    
    func createBarChart(dataPoints: [String], values: [Double]) {
        print(self.frame.height, self.frame.width)
        let barChart =  BarChartView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height))
        print(barChart.frame.minX, barChart.frame.minY, barChart.frame.maxX, barChart.frame.maxY)
        barChart.noDataText = "please enter data"
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<values.count {
            
            
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            //(value: values[i], xIndex: i)
            
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Connected visitors hourly")
        let chartData = BarChartData(dataSet: chartDataSet)
        let legend = barChart.legend
        legend.enabled = true
        legend.verticalAlignment = .top
        barChart.xAxis.labelFont = UIFont.systemFont(ofSize: 9)
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:dataPoints)
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.drawAxisLineEnabled = true
        barChart.xAxis.drawGridLinesEnabled = true
        // barChart.xAxis.centerAxisLabelsEnabled = true
        barChart.xAxis.enabled = true
        // barChart.xAxis.granularityEnabled = true
        barChart.xAxis.axisMinimum = 0.0
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.labelRotationAngle = -90
        barChart.rightAxis.drawLabelsEnabled = false
        barChart.rightAxis.enabled = false
        barChart.rightAxis.drawLabelsEnabled = false
        barChart.rightAxis.drawGridLinesEnabled = true
        barChart.leftAxis.enabled = false
        barChart.leftAxis.drawAxisLineEnabled = false
        barChart.leftAxis.drawGridLinesEnabled = false
        barChart.notifyDataSetChanged()
        barChart.xAxis.labelCount = dataPoints.count
        barChart.xAxis.labelFont = UIFont.systemFont(ofSize: 9)
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:dataPoints)
        barChart.notifyDataSetChanged()
        barChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        barChart.data = chartData
        
        
        barChart.translatesAutoresizingMaskIntoConstraints = true
        barChart.topAnchor.constraint(equalTo: self.topAnchor)
        barChart.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        barChart.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        barChart.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        self.addSubview(barChart)
    }
    
    func createGroupedBarChart(dataPoints: [String], values: [[Double]]) {
        
        var dataEntryArr : [[BarChartDataEntry]] = []
        
        print(self.frame.height, self.frame.width)
        let barChart =  BarChartView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height))
        print(barChart.frame.minX, barChart.frame.minY, barChart.frame.maxX, barChart.frame.maxY)
        barChart.noDataText = "please enter data"
        
        for one in 0..<values.count{
            var dataEntries: [BarChartDataEntry] = []
            for i in 0..<values[one].count {
                let dataEntry = BarChartDataEntry(x: Double(i), y: values[one][i])
                dataEntries.append(dataEntry)
            }
            dataEntryArr.append(dataEntries)
        }
        
        var dataSets : [BarChartDataSet] = []
///https://stackoverflow.com/questions/35294076/how-to-make-a-grouped-barchart-with-ios-charts        var dataSets: [BarChartDataSet] = []
        let labels = ["Connected", "Passerby", "Visitor"]
        for i in 0..<dataEntryArr.count{
            let set = BarChartDataSet(entries: dataEntryArr[i], label: labels[i])
            
            dataSets.append(set)
        }
        for i in 0..<dataSets.count{
            dataSets[i].colors = [getColor(int: i)]
        }
        
        let chartData = BarChartData(dataSets: dataSets)
        barChart.data = chartData
        
        
        let legend = barChart.legend
        legend.enabled = true
        legend.verticalAlignment = .top
        barChart.xAxis.labelFont = UIFont.systemFont(ofSize: 9)
        
        
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        // (0.3 + 0.05) * 2 + 0.3 = 1.00 -> interval per "group"
        
        let groupCount = values[0].count
        let startYear = 0
        chartData.barWidth = barWidth;
        barChart.xAxis.axisMinimum = Double(startYear)
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        print("Groupspace: \(gg)")
        barChart.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
        
        chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
        //chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        barChart.notifyDataSetChanged()
        
        
        
        
        
        
        
        //background color
        barChart.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        
        //chart animation
        barChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        designBarChart(barChart: barChart, dataPoints: dataPoints)
        self.addSubview(barChart)
    }
    
    func designBarChart(barChart : BarChartView, dataPoints: [String]){
        let xaxis = barChart.xAxis
        xaxis.drawGridLinesEnabled = true
        xaxis.labelPosition = .bottom
        xaxis.valueFormatter = IndexAxisValueFormatter(values : dataPoints)
       // xaxis.labelCount = dataPoints.count
        xaxis.labelRotationAngle = -90
        barChart.rightAxis.drawLabelsEnabled = false
        barChart.rightAxis.enabled = false
     
    }
    
    func createLinearChart(hours: [String], allDwell : [(key: Int, value: AnyObject)]){
        let lineChart = LineChartView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height))
        lineChart.noDataText = "please enter data"
        print(allDwell)
        let data = LineChartData()
        
        let HoursDwell = ["FIVE_TO_THIRTY_MINUTES", "ONE_TO_FIVE_HOURS", "EIGHT_PLUS_HOURS", "FIVE_TO_EIGHT_HOURS", "THIRTY_TO_SIXTY_MINUTES"]
        
       // var dataEntryArr : [[ChartDataEntry]] = []
        //print("keys>>>",allDwell)
        for i in 0..<HoursDwell.count{
            var lineChartEntry = [ChartDataEntry]()
            
            for j in 0..<allDwell.count{
                if let val = allDwell[j].value[HoursDwell[i]]{
                    print(val as! Double)
                    lineChartEntry.append(ChartDataEntry(x: Double(allDwell[j].key), y: val as! Double))
                }
            }
//            print(allDwell[i].key)
//
//            let val = allDwell[i].value
//
//            if let value = val["EIGHT_PLUS_HOURS"]{
//                print(">>>>>>>>>>>>>>>>>>>> EIGHT_PLUS_HOURS", value ?? 0)
//            }
//            for i in 0..<allDwell[i] {
//                let dataEntry = ChartDataEntry(x: Double(i), y: Double(x1[i]) ?? 0.0)
//                lineChartEntry.append(dataEntry)
//            }
            let line = LineChartDataSet(entries: lineChartEntry, label: HoursDwell[i])
            data.addDataSet(line)
        }
       
//
//        let data = LineChartData()
//        var lineChartEntry1 = [ChartDataEntry]()
//
//        for i in 0..<x1.count {
//            lineChartEntry1.append(ChartDataEntry(x: Double(i), y: Double(x1[i]) ?? 0.0))
//        }
//        let line1 = LineChartDataSet(values: lineChartEntry1, label: "First Dataset")
//        data.addDataSet(line1)
//        if (x2.count > 0) {
//            var lineChartEntry2 = [ChartDataEntry]()
//            for i in 0..<x2.count {
//                lineChartEntry2.append(ChartDataEntry(x: Double(i), y: Double(x2[i]) ?? 0.0))
//            }
//            let line2 = LineChartDataSet(values: lineChartEntry2, label: "Second Dataset")
//            data.addDataSet(line2)
//        }
//        if (x3.count > 0) {
//            var lineChartEntry3 = [ChartDataEntry]()
//            for i in 0..<x3.count {
//                lineChartEntry3.append(ChartDataEntry(x: Double(i), y: Double(x3[i]) ?? 0.0))
//            }
//            let line3 = LineChartDataSet(values: lineChartEntry3, label: "Third Dataset")
//            data.addDataSet(line3)
//        }
//        self.myChartView.data = data
        lineChart.data = data
        self.addSubview(lineChart)
        
    }
    
    func createPieChart(dataPoints: [String], values: [Double]){
        let pieChart = PieChartView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height))
        pieChart.noDataText = "please enter data"
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<values.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        let chartDataSet = PieChartDataSet(entries: dataEntries, label: "Pie chart connected  visitors hourly")
        let chartData = PieChartData()
        
        chartData.addDataSet(chartDataSet)
        pieChart.data = chartData
        
        self.addSubview(pieChart)
        
        
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
        default:
            return UIColor(red: 1, green: 0.0784, blue: 0.5765, alpha: 1.0) /* #ff1493 */
        }
    }
}

