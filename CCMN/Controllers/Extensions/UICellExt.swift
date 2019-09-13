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
    
    func createLinearChartString(datapoints: [String], allDwell : [(key: String, value: AnyObject)], timeSpanLabels : [String], addGradient : Bool){
        let lineChart = LineChartView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height))
        lineChart.noDataText = "please enter data"
        if (datapoints.count == 0 || allDwell.count == 0 || timeSpanLabels.count == 0 ){
            self.addSubview(lineChart)
            return
        }
        
        let data = LineChartData()
        
        for i in 0..<timeSpanLabels.count{
            var lineChartEntry = [ChartDataEntry]()
            //print("------------------------------------------------")
            for j in 0..<allDwell.count{
                if let val = allDwell[j].value[timeSpanLabels[i]]{
                    // print(val as! Double)
                    // print("***", j, "***")
                    lineChartEntry.append(ChartDataEntry(x: Double(j), y: val as! Double))
                }
            }
            let line = LineChartDataSet(entries: lineChartEntry, label: timeSpanLabels[i])
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
        designLinearChart(lineChart : lineChart, datapoints : datapoints)
        
        lineChart.data = data
        self.addSubview(lineChart)
        
    }
    
    func designLinearChart(lineChart : LineChartView, datapoints : [String]){
        let legend = lineChart.legend
        legend.enabled = true
        legend.verticalAlignment = .top
        lineChart.leftAxis.axisMinimum = 0
        // lineChart.xAxis.labelRotationAngle = -45
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.labelCount = 12
        lineChart.xAxis.labelFont = UIFont.systemFont(ofSize: 9)
        lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:datapoints)
        lineChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
    }
    
    
    
    
    
    func createGroupedBarChart(dataPoints: [String], values: [[Double]]) {
        let barChart =  BarChartView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height))
        barChart.noDataText = "please enter data"
        if dataPoints.count != 0 && values.count != 0 {
            barChart.fillDatasets(dataPoints : dataPoints, values: values)
            barChart.designBarChart(dataPoints: dataPoints)
        }
        self.addSubview(barChart)
    }
    
    
    
    
    
    func createPieChart(dataPoints: [String], values: [Double], chartName : String){
        let pieChart = PieChartView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height))
        
        pieChart.holeRadiusPercent = 0.0
        pieChart.transparentCircleRadiusPercent = 0
        
        pieChart.noDataText = "please enter data"
        
        if (dataPoints.count == 0 || values.count == 0){
            self.addSubview(pieChart)
            return
        }
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<values.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        let chartDataSet = PieChartDataSet(entries: dataEntries, label: chartName)
        //append color values
        let legend = pieChart.legend
        legend.enabled = true
        legend.verticalAlignment = .top
        
        var  colors: [UIColor] = []
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        chartDataSet.colors = colors
        
        chartDataSet.yValuePosition = .outsideSlice
        
        chartDataSet.valueTextColor = .black
        pieChart.drawEntryLabelsEnabled = false       // pieChart.setDrawSliceText(false)
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
