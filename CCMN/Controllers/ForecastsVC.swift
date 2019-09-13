//
//  ForecastsVC.swift
//  CCMN
//
//  Created by ANASTASIA on 9/3/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

//https://www.machinelearningplus.com/time-series/arima-model-time-series-forecasting-python/

import Foundation
import UIKit
import Charts
import CoreML
import Alamofire
class  ForecastsVC: UIViewController {
    
    
    @IBOutlet weak var someViewForVisualization: UIView!
    var selectedDate : Date = Date()
    var datapoints : [String] = []
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var resultOfForecastLabel: UILabel!
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        selectedDate = datePicker.date
        //print(selectedDate)
        forecastNbrOf(visitorsType : "connected", completion: {
            loaded, error in
            if let err = error {
                self.callErrorWithCustomMessage("Couldn't get the necessary info. Please try again")
                self.logError(timestamp: Int32(Date().getTimeStamp()), ErrorMsg: NSString(string: err.localizedDescription))
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var components = DateComponents()
        components.year = 10
        let maxDate = Calendar.current.date(byAdding: components, to: Date())
        datePicker.minimumDate = Date()
        datePicker.maximumDate = maxDate
        
        print("Hi from forecast vc ")
        forecastNbrOf(visitorsType : "connected", completion: {
            loaded, error in
            if let err = error {
                self.callErrorWithCustomMessage("Couldn't get the necessary info. Please try again")
                self.logError(timestamp: Int32(Date().getTimeStamp()), ErrorMsg: NSString(string: err.localizedDescription))
            }
        })
        
        
        
    }
    
    func forecastNbrOf(visitorsType : String, completion: @escaping (Bool, Error?) -> Void){
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
                self.createGroupedBarChart(dataPoints: self.datapoints, values: resultingData)
                completion(true, nil)
            }
            else if let err = error{
                completion(false, err)
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
    
    
    func prediction(input:[Double], resultDayNbr : Int) -> [Double]{
        typealias PointTuple = (day: Double, mW: Double)
        var points: [PointTuple] = []
        for i in 0..<input.count {
            points.append(PointTuple(Double(i), input[i]))
            
            
        }
        
        let meanDays = points.reduce(0) { $0 + $1.day } / Double(points.count)
        let meanMW   = points.reduce(0) { $0 + $1.mW  } / Double(points.count)
        
        let a = points.reduce(0) { $0 + ($1.day - meanDays) * ($1.mW - meanMW) }
        let b = points.reduce(0) { $0 + pow($1.day - meanDays, 2) }
        
        // The equation of a straight line is: y = mx + c
        // Where m is the gradient and c is the y intercept.
        let m = a / b
        let c = meanMW - m * meanDays
        
        var TempSetRes : [Double] = []
        
        for i in input.count..<resultDayNbr{
            
            TempSetRes.append(m * Double(i) + c)
        }
        return TempSetRes
        //
        //        var array : [NSNumber] = []
        //        for one in input {
        //            array.append(NSNumber(value: one))
        //        }
        //        let sequence = MLSequence(int64s:array)
        
    }
    ///////////////////////////////////// makePrediction  /////////////////////////////////////////////////
    
    
    func predictAvg(input : [Double], resultDayNbr : Int) ->[Double ] {//
        let startDayIndex = input.count - 1
        var tempSet = [Double]()
        
        
        var forecastedRow  = input
        for i in startDayIndex..<resultDayNbr { //for every new day
            var tempForAvg : [Double] = []
            var j = i
            while(j >= 0){
                //print("j: ", j)
                tempForAvg.append(forecastedRow[j])
                j = j - 7
            }
            let sum = tempForAvg.reduce(0, +)
            //print("Sum of Array is : ", sum)
            let res = sum / Double(tempForAvg.count)
            // print("Sres is : ", res)
            forecastedRow.append(res)
            tempSet.append(res)
        }
        if (tempSet.count >= 1){
            self.resultOfForecastLabel.text = "Estimated number of visitors: \(Int(tempSet[tempSet.count - 1]))"
        }
        return tempSet
        
    }
    
    
    
    
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
        //requestForecast(data : data)
        //  return prediction(input : numberOfVisitors, resultDayNbr : resultDayNbr)
        return predictAvg(input : numberOfVisitors, resultDayNbr : resultDayNbr)
        //  print(">>>>>>>>>>>>  resultDayNbr : ", resultDayNbr)
        //  print(">>>>>>>>>>>>  number of days to extrapolate : ", timeInterval)
        /// don't touch it
        /*
         var tempSet : [Double] = []
         for i in 0..<timeInterval{
         // print(daysInPeriod.count + i)
         
         let result = Int(self.linearRegression(daysInPeriod, numberOfVisitors)(Double(resultDayNbr - i)))
         
         
         //daysInPeriod.append(Double(daysInPeriod.count + i))
         //numberOfVisitors.append(Double(result))
         
         tempSet.append(Double(result))
         }
         
         let result = self.linearRegression(daysInPeriod, numberOfVisitors)(Double(resultDayNbr))
         //print("on this date the predicted number of connected visitors is about to be \(Int(result))")
         
         self.resultOfForecastLabel.text = self.resultOfForecastLabel.text ?? "" + "\(visitorsType) : \(Int(result))"
         return tempSet.reversed()
         
         */
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
    func createGroupedBarChart(dataPoints: [String], values: [Double]) {
        for one in self.someViewForVisualization.subviews{
              one.removeFromSuperview()
        }
        print(dataPoints)
        //   print(self.frame.height, self.frame.width)
        let barChart =  BarChartView(frame: CGRect(x: 0.0, y: 0.0, width: self.someViewForVisualization.frame.width, height: self.someViewForVisualization.frame.height))
        //print(barChart.frame.minX, barChart.frame.minY, barChart.frame.maxX, barChart.frame.maxY)
        barChart.noDataText = "No prediction can be made."
        if dataPoints.count == 0 || values.count == 0{
            self.someViewForVisualization.addSubview(barChart)
            return
        }
       
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<values.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Connected count")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChart.data = chartData
        
        let legend = barChart.legend
        legend.enabled = true
        legend.verticalAlignment = .top
        
        barChart.xAxis.labelFont = UIFont.systemFont(ofSize: 9)
        let xaxis = barChart.xAxis
        xaxis.drawGridLinesEnabled = true
        xaxis.labelPosition = .bottom
        xaxis.valueFormatter = IndexAxisValueFormatter(values : dataPoints)
        xaxis.avoidFirstLastClippingEnabled = true
        xaxis.labelCount = 12 //dataPoints.count
        barChart.leftAxis.axisMinimum = 0.0
        barChart.xAxis.granularity = 1
        barChart.xAxis.avoidFirstLastClippingEnabled = false
        barChart.xAxis.drawLabelsEnabled = false
        //self.axisMinimum = 0.0
        //xaxis.labelRotationAngle = -45
        barChart.rightAxis.drawLabelsEnabled = false
        barChart.rightAxis.enabled = false
        barChart.backgroundColor = UIColor(red:0.54, green:0.17, blue:0.89, alpha:1.0)
        barChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        self.someViewForVisualization.addSubview(barChart)
    }
    
    func designBarChart(barChart : BarChartView, dataPoints: [String]){
        let xaxis = barChart.xAxis
        xaxis.drawGridLinesEnabled = true
        xaxis.labelPosition = .bottom
        xaxis.valueFormatter = IndexAxisValueFormatter(values : dataPoints)
        xaxis.labelCount = 10
        xaxis.labelRotationAngle = -45
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

/*
 func requestForecast(data : [(key: String, value: Int)]){
 
 let baseURL = "https://api.unplu.gg/"
 let jsonEncoder = JSONEncoder()
 var timeValArr = [TimeValue]()
 for one in data{
 let date = one.key.toDateCustom(format: "yyyy-MM-dd")
 let timestamp = date!.getTimeStamp()
 //print(timestamp)
 
 timeValArr.append(TimeValue(timestamp: timestamp, value: Double(one.value)))
 }
 let forecast_to = self.selectedDate.getTimeStamp()
 let infoToSend = TimeSeries(timeValue: timeValArr, forecast_to: forecast_to, callback: "https://intra.42.fr")
 guard let jsonData = try? jsonEncoder.encode(infoToSend) else {
 print("couldn't encode")
 return
 }
 let APIKey = "e183b00b50801f530bafdefe9149b869b84f9b8594f59cd665ab84b421264867"
 
 
 let json = try! JSONSerialization.jsonObject(with: jsonData, options: []) as? [String : Any]
 //print(json)
 
 
 
 
 
 //        let params : [String : Any] = ["data" : arr, "forecast_to" : 1458126000, "callback":  "https://intra.42.fr"]
 
 
 Client.sharedInstance.manager.request( "https://api.unplu.gg/forecast",
 method: .post,
 parameters: json,
 encoding: JSONEncoding.default,
 headers: ["x-access-token" : APIKey, "Content-Type" : "application/json"]).validate().responseData {
 response in
 switch response.result {
 case .success:
 if let value = response.result.value{
 if let json = try? JSONSerialization.jsonObject(with: value, options: []){
 print(json)
 }
 }
 print("success getting smoething")
 case .failure(let error):
 print("failure to perform req")
 print(error)
 }
 }
 }
 */
