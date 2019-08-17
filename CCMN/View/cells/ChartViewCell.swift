//
//  ChartViewCell.swift
//  CCMN
//
//  Created by ANASTASIA on 8/15/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
import UIKit
import Charts

class ChartViewCell : UITableViewCell{
    
    @IBOutlet weak var barChart: BarChartView!
    
    class func reuseIdentifier() -> String {
        return "ChartViewCell"
    }
    
    // Nib name
    class func nibName() -> String {
        
        return "ChartViewCell"
    }
    
    // Cell height

    
    // Awake from nib method
    override func awakeFromNib() {
        super.awakeFromNib()
         barChart.noDataText = "You need to provide data for the chart."

    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        barChart.noDataText = "You need to provide data for the chart."
   
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            
            
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            //(value: values[i], xIndex: i)
          
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Connected visitors hourly")
        let chartData = BarChartData(dataSet: chartDataSet)
        
        barChart.xAxis.labelFont = UIFont.systemFont(ofSize: 9)
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:dataPoints)
       
        
        barChart.notifyDataSetChanged()
        barChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        barChart.data = chartData
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

    
}
