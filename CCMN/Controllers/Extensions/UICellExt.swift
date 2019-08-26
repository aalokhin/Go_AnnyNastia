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
    
    func createLinearChart(hours: [String], allDwell : [(key: Int, value: AnyObject)], timeLabels : [String], addGradient : Bool){
        let lineChart = LineChartView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height))
        lineChart.noDataText = "please enter data"
        print(allDwell)
        let data = LineChartData()
        
        //let HoursDwell = ["FIVE_TO_THIRTY_MINUTES", "ONE_TO_FIVE_HOURS", "EIGHT_PLUS_HOURS", "FIVE_TO_EIGHT_HOURS", "THIRTY_TO_SIXTY_MINUTES"]
        
       // var dataEntryArr : [[ChartDataEntry]] = []
        //print("keys>>>",allDwell)
        for i in 0..<timeLabels.count{
            var lineChartEntry = [ChartDataEntry]()
            
            for j in 0..<allDwell.count{
                if let val = allDwell[j].value[timeLabels[i]]{
                    print(val as! Double)
                    lineChartEntry.append(ChartDataEntry(x: Double(allDwell[j].key), y: val as! Double))
                }
            }
            let line = LineChartDataSet(entries: lineChartEntry, label: timeLabels[i])
            line.colors = [getColor(int: i)]
            line.drawValuesEnabled = false

            if (addGradient){
                let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [getColor(int: i).cgColor, getColor(int: i).cgColor] as CFArray, locations: [1.0, 0.0]) // Gradient Object
                line.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
                line.drawFilledEnabled =  true// Draw the Gradient
            }
                line.circleRadius = 2.5
                line.circleColors = [getColor(int: i), getColor(int: i)]
                line.circleHoleRadius = 1.3
                data.addDataSet(line)
        }
        let legend = lineChart.legend
        legend.enabled = true
        legend.verticalAlignment = .top
        
        lineChart.data = data
        lineChart.xAxis.labelRotationAngle = -90
        lineChart.xAxis.labelPosition = .bottom
    
        lineChart.xAxis.labelCount = hours.count
        lineChart.xAxis.labelFont = UIFont.systemFont(ofSize: 9)
        lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:hours)
        lineChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
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
        case 4:
            return UIColor(hue: 0.0778, saturation: 1, brightness: 0.94, alpha: 1.0) /* #ef6f00 */
        case 5:
            return UIColor(hue: 0.9333, saturation: 1, brightness: 0.66, alpha: 1.0) /* #a80043 */
        default:
            return UIColor(red: 1, green: 0.0784, blue: 0.5765, alpha: 1.0) /* #ff1493 */
        }
    }
}

