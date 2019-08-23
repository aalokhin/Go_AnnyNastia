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

extension UITableViewCell{
    func createBarChart(dataPoints: [String], values: [Double]) {
        print(self.frame.height, self.frame.width)
        let barChart =  BarChartView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height))
        print(barChart.frame.minX, barChart.frame.minY, barChart.frame.maxX, barChart.frame.maxY)
        barChart.noDataText = "please enter data"
        
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            
            
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
        barChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
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
    
    func createLinearChart(dataPoints: [String], values: [Double]){
        let lineChart = LineChartView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height))
        lineChart.noDataText = "please enter data"
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            
            
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            //(value: values[i], xIndex: i)
            
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "Connected visitors hourly")
        let chartData = LineChartData()
        chartData.addDataSet(chartDataSet)
        lineChart.data = chartData
        
        
        
        self.addSubview(lineChart)
        
    }
    
    func createPieChart(dataPoints: [String], values: [Double]){
        let pieChart = PieChartView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height))
        pieChart.noDataText = "please enter data"
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        let chartDataSet = PieChartDataSet(entries: dataEntries, label: "Pie chart connected  visitors hourly")
        let chartData = PieChartData()
        
        chartData.addDataSet(chartDataSet)
        pieChart.data = chartData
        
        self.addSubview(pieChart)
        
        
    }
}

