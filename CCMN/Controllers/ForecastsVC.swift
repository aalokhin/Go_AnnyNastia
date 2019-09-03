//
//  ForecastsVC.swift
//  CCMN
//
//  Created by ANASTASIA on 9/3/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
import UIKit

class  ForecastsVC: UIViewController {
    var selectedDate : Date = Date()
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var resultOfForecastLabel: UILabel!
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        selectedDate = datePicker.date
        print(selectedDate)
        forecastNbrOf(visitorsType : "visitor")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date()
        print("Hi from forecast vc ")
       
        forecastNbrOf(visitorsType : "visitor") //"passerby" "connected"
       
        
        
    }
    
    func forecastNbrOf(visitorsType : String){
        
        let endDate : Date = Date(timeInterval: -86400, since: Date())
        let endDateStr : String = endDate.toStringDefault() //check until yesterday
        
        let startDate : Date = Date(timeInterval: (-86400 * 31 * 15), since: Date())
        let startDateStr : String = startDate.toStringDefault()//starting form 6 months ago
        
        let siteId = Client.sharedInstance.siteID?.aesUidString ?? "1513804707441"
        
        
        let timeInterval = selectedDate.interval(ofComponent: .day, fromDate: endDate)
        print(">>>>>>>>>>>>", timeInterval)
        
        let url = "api/presence/v1/\(visitorsType)/daily?siteId=\(siteId)&startDate=\(startDateStr)&endDate=\(endDateStr)"
        NetworkManager.getRequestData(isLocation: false, endpoint: url, params: [:], method: .get, completion: {
            data, error in
            if let d = data{
//              if let json = try? JSONSerialization.jsonObject(with: d, options: []){
//                 print(json)
//              }
                guard let t = try? JSONDecoder().decode([String : Int].self, from: d) else {
                    print("error decoding json")
                    return
                }
                print(t.count)
                
                
                var dayInPeriod: [Double] = []
                var numberOfVisitors: [Double] = []
                for i in 0..<t.count {
                    dayInPeriod.append(Double(i))
                }
                for one in t{
                    numberOfVisitors.append(Double(one.value))
                }
                
                
                
                let result = self.linearRegression(dayInPeriod, numberOfVisitors)(466)
                
                print("on this date the predicted number of connected visitors is about to be \(Int(result))")
                self.resultOfForecastLabel.text = "\(visitorsType) : \(Int(result))"
                
                
                
            }
        })
        
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
 
}






/////////////////////////
func forecastHourly(){
    let endDate : String = Date(timeInterval: -86400, since: Date()).toStringDefault() //check until yesterday
    let startDate : String = Date(timeInterval: (-86400 * 31 * 6), since: Date()).toStringDefault()//starting form 6 months ago
    
    let url = "api/presence/v1/connected/hourly?siteId=1513804707441&date=\(startDate)"
    NetworkManager.getRequestData(isLocation: false, endpoint: url, params: [:], method: .get, completion: {
        data, error in
        if let d = data{
            if let json = try? JSONSerialization.jsonObject(with: d, options: []){
                print(json)
            }
        }
    })
}
