//
//  EncodableForecast.swift
//  CCMN
//
//  Created by ANASTASIA on 9/5/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation

class TimeValue : Encodable{
    let timestamp : Int64
    let value : Double
    
    enum CodingKeys : String, CodingKey {
        case timestamp = "timestamp"
        case value = "value"
    }
    init(timestamp : Int64, value : Double)
    {
        self.timestamp = timestamp
        self.value = value
    }
    
}

class TimeSeries : Encodable {
    //required values
    
    let data : [TimeValue]
    let forecast_to : Int64
    let callback : String
    
    enum CodingKeys : String, CodingKey {
        case data = "data"
        case forecast_to = "forecast_to"
        case callback = "callback"
    }
    
    init(timeValue : [TimeValue], forecast_to : Int64, callback : String)
    {
        self.data = timeValue
        self.forecast_to = forecast_to
        self.callback = callback

    }
}

