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
        
//       let hours = ["12am-01am", "01am-02am", "02am-03am", "03am-04am", "04am-05am",  "05am-06am", "06am-07am", "07am-08am", "08am-09am", "09am-10am", "10am-11am", "11am-12pm", "12pm-01pm", "01pm-02pm", "02pm-03pm", "03pm-04pm", "04pm-05pm", "05pm-06pm", "06pm-07pm", "07pm-08pm", "08pm-09pm", "09pm-10pm", "10pm-11pm", "11pm-12am"]
//        let values = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0, 20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
//
//        setChart(dataPoints : hours, values: values)        // Initialization code
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        barChart.noDataText = "You need to provide data for the chart."
   
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            
            
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            //(value: values[i], xIndex: i)
          
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Units Sold")
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
