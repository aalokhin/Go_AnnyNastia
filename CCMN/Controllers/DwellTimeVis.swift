//
//  DwellTimeVis.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 8/14/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//https://medium.com/@stasost/ios-how-to-build-a-table-view-with-multiple-cell-types-2df91a206429

import Foundation
import UIKit
import Charts

class DwellTimeVis : UIViewController {
    var startDate = ""
    var endDate = ""
    var YValues : [Double] = []
    var HoursYValues : [String:Double]?
    let HoursForDic = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
    let hours = ["12am-01am", "01am-02am", "02am-03am", "03am-04am", "04am-05am",  "05am-06am", "06am-07am", "07am-08am", "08am-09am", "09am-10am", "10am-11am", "11am-12pm", "12pm-01pm", "01pm-02pm", "02pm-03pm", "03pm-04pm", "04pm-05pm", "05pm-06pm", "06pm-07pm", "07pm-08pm", "08pm-09pm", "09pm-10pm", "10pm-11pm", "11pm-12am"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        print("hi from vis vc")
        super.viewDidLoad()
        setupVC()
       // getDwell()
        getHourlyConnected()
        print("start-", startDate, "end-", endDate)
        
    }
    func setupVC() {

        
        tableView.register(UINib(nibName: ChartViewCell.nibName(), bundle: nil), forCellReuseIdentifier: ChartViewCell.reuseIdentifier())
        tableView.register(UINib(nibName: EmptyChartCell.nibName(), bundle: nil), forCellReuseIdentifier: EmptyChartCell.reuseIdentifier())

        self.tableView.rowHeight = 400.0

    }
    
    func getHourlyConnected(){
        let siteId = Client.sharedInstance.siteID?.aesUidString ?? "1513804707441"

        NetworkManager.getRequestData(isLocation: false, endpoint: "api/presence/v1/connected/hourly/yesterday?siteId=\(siteId)", params: [:], method: .get, completion: {
            data, error in
            if let d = data{
                print("connected/hourly/yesterday \n\n")
                
//                if let json = try? JSONSerialization.jsonObject(with: d, options: []){
//
//                    print(json)
//                }
                
                let decoder = JSONDecoder()
                guard let t = try? decoder.decode([String : Int].self, from: d) else {
                    print("error decoding json")
                    return
                }
                print(t)
                for one in self.HoursForDic {
                    let value = Double(t[one] ?? -1)
                    self.YValues.append(value)
                    //print(one, "==>", value)
                }
                self.tableView.reloadData()
            }
            
        })
    }
    
    func getDwell(){
        NetworkManager.getRequestData(isLocation: false, endpoint: "api/presence/v1/kpisummary?siteId=1513804707441&startDate=\(startDate)&endDate=\(endDate)", params: [:], method: .get, completion: {
            data, error in
            if let d = data{
                print("kpisummary/today\n\n")
                
                if let json = try? JSONSerialization.jsonObject(with: d, options: []){
                    print(json)
                }
                let decoder = JSONDecoder()
                guard let t = try? decoder.decode(kpiSummaryJSON.self, from: d) else {
                    print("error decoding json")
                    return
                }
                t.prinAll()

            }
            
        })
        
    }
}

extension DwellTimeVis : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (YValues.count == 0){
            return 0
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
       // getHourlyConnected()
       let values = YValues
        //let values = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0, 20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyChartCell.reuseIdentifier()) as! EmptyChartCell
            cell.createLinearChart(dataPoints: hours, values: values)
            return cell
        } else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyChartCell.reuseIdentifier()) as! EmptyChartCell
            cell.createPieChart(dataPoints: hours, values: values)
            return cell

        }
        let cell = tableView.dequeueReusableCell(withIdentifier: EmptyChartCell.reuseIdentifier()) as! EmptyChartCell
        cell.createBarChart(dataPoints: hours, values: values)
        return cell
       
    }
    
    //https://medium.com/@felicity.johnson.mail/lets-make-some-charts-ios-charts-5b8e42c20bc9
    
   
    
    
}


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
            //(value: values[i], xIndex: i)
            
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = PieChartDataSet(entries: dataEntries, label: "Connected visitors hourly")
        let chartData = PieChartData()
        chartData.addDataSet(chartDataSet)
        pieChart.data = chartData
        
        self.addSubview(pieChart)
        
        
    }
}

