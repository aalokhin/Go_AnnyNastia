//
//  ForecastsVC.swift
//  CCMN
//
//  Created by ANASTASIA on 9/3/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
import UIKit
import Charts

class  ForecastsVC: UIViewController {
    
    
    @IBOutlet weak var someViewForVisualization: UIView!
    var selectedDate : Date = Date()
    var datapoints : [String] = []
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var resultOfForecastLabel: UILabel!
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        selectedDate = datePicker.date
        //print(selectedDate)
        forecastNbrOf(visitorsType : "visitor")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date()
        print("Hi from forecast vc ")
        forecastNbrOf(visitorsType : "connected") //"visitor", "passerby" "connected"
       
        
        
    }
    
    func forecastNbrOf(visitorsType : String){
        self.resultOfForecastLabel.text = ""
        self.datapoints.removeAll()
        
        
        let endDate : Date = Date(timeInterval: -86400, since: Date())
        let endDateStr : String = endDate.toStringDefault() //check until yesterday
        
        let startDate : Date = Date(timeInterval: (-86400 * 31 * 15), since: Date())
        let startDateStr : String = startDate.toStringDefault()//starting form 6 months ago
        
        let siteId = Client.sharedInstance.siteID?.aesUidString ?? "1513804707441"
        let url = "api/presence/v1/\(visitorsType)/daily?siteId=\(siteId)&startDate=\(startDateStr)&endDate=\(endDateStr)"
        
        NetworkManager.getRequestData(isLocation: false, endpoint: url, params: [:], method: .get, completion: {
            data, error in
            if let d = data{
                guard let t = try? JSONDecoder().decode([String : Int].self, from: d) else {
                    print("error decoding json")
                    return
                }
                let sortedData = t.sorted(by: { $0.key.toDateCustom(format: "yyyy-MM-dd")! < $1.key.toDateCustom(format: "yyyy-MM-dd")! })
                let resultingData = self.makePrediction(visitorsType : visitorsType, data: sortedData, endDate: endDate, startDate: startDate)
                for i in 0..<resultingData.count{
                    self.datapoints.append(Date(timeInterval: (TimeInterval(86400 * i)), since: Date()).toStringDefault())
                }
                //print(self.datapoints)
                //print(resultingData)
                self.createGroupedBarChart(dataPoints: self.datapoints, values: [resultingData])
            }
        })
        
    }
    
    
//    static func getDictionaries(_ urlEndpoint : String, _ parameters : Parameters, completion: @escaping ([Double], Error?) -> Void){
//        getRequestData(isLocation: true, endpoint : urlEndpoint, params : parameters, method : .get, completion: { data, error in
//            if let d =  data {
//                if let downloadedImage = UIImage(data:d) {
//                    completion(tempSet, nil)
//                }
//            } else if let err = error {
//                print(err.localizedDescription)
//            }
//        })
//    }
    
    
    
    func makePrediction(visitorsType : String, data : [(key: String, value: Int)], endDate : Date, startDate : Date) -> [Double]{
        
        
        var daysInPeriod: [Double] = []
        var numberOfVisitors: [Double] = []
        
        for i in 0..<data.count {
            daysInPeriod.append(Double(i))
        }
        for one in data{
            datapoints.append(one.key)
            numberOfVisitors.append(Double(one.value))
        }
        
        let resultDayNbr = self.selectedDate.interval(ofComponent: .day, fromDate: startDate) //the order number  of the day in extrapolated sequence  from start till selected date
        
        let timeInterval = self.selectedDate.interval(ofComponent: .day, fromDate: endDate) // the number of days to extrapolate from end date of data set until the selected datte
        
        //  print(">>>>>>>>>>>>  resultDayNbr : ", resultDayNbr)
        //  print(">>>>>>>>>>>>  number of days to extrapolate : ", timeInterval)
        /// don't touch it
       

        var tempSet : [Double] = []

        for i in 0..<timeInterval{
           // print(daysInPeriod.count + i)
           
            let result = Int(self.linearRegression(daysInPeriod, numberOfVisitors)(Double(resultDayNbr - i)))
            
            
            daysInPeriod.append(Double(daysInPeriod.count + i))
            numberOfVisitors.append(Double(result))
            
            tempSet.append(Double(result))

        }
        
        let result = self.linearRegression(daysInPeriod, numberOfVisitors)(Double(resultDayNbr))
        //print("on this date the predicted number of connected visitors is about to be \(Int(result))")
        
        self.resultOfForecastLabel.text = self.resultOfForecastLabel.text ?? "" + "\(visitorsType) : \(Int(result))"
        return tempSet.reversed()
    }
    
    func average(_ input: [Double]) -> Double {
        return input.reduce(0, +) / Double(input.count)
    }
    
    func multiply(_ a: [Double], _ b: [Double]) -> [Double] {
        return zip(a, b).map(*)
    }
    
    func linearRegression(_ xs: [Double], _ ys: [Double]) -> (Double) -> Double {
        let sum1 = average(multiply(xs, ys)) - average(xs) * average(ys)
        let sum2 = average(multiply(xs, xs)) - pow(average(xs), 2)
        let slope = sum1 / sum2
        let intercept = average(ys) - slope * average(xs)
        return { x in intercept + slope * x }
    }
    
    
    
    
    
    
    ////////////////////////////////////chart
    func createGroupedBarChart(dataPoints: [String], values: [[Double]]) {
        
        var dataEntryArr : [[BarChartDataEntry]] = []
        
        //   print(self.frame.height, self.frame.width)
        let barChart =  BarChartView(frame: CGRect(x: 0.0, y: 0.0, width: self.someViewForVisualization.frame.width, height: self.someViewForVisualization.frame.height))
        //print(barChart.frame.minX, barChart.frame.minY, barChart.frame.maxX, barChart.frame.maxY)
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
        //  print("Groupspace: \(gg)")
        barChart.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
        
        chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
        //chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        barChart.notifyDataSetChanged()
        
        //background color
        barChart.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        
        //chart animation
        barChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        designBarChart(barChart: barChart, dataPoints: dataPoints)
        self.someViewForVisualization.addSubview(barChart)
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






/////////////////////////
//func forecastHourly(){
//    let endDate : String = Date(timeInterval: -86400, since: Date()).toStringDefault() //check until yesterday
//    let startDate : String = Date(timeInterval: (-86400 * 31 * 6), since: Date()).toStringDefault()//starting form 6 months ago
//    
//    let url = "api/presence/v1/connected/hourly?siteId=1513804707441&date=\(startDate)"
//    NetworkManager.getRequestData(isLocation: false, endpoint: url, params: [:], method: .get, completion: {
//        data, error in
//        if let d = data{
//            if let json = try? JSONSerialization.jsonObject(with: d, options: []){
//               // print(json)
//            }
//        }
//        
//        
//        
//    })
//}
