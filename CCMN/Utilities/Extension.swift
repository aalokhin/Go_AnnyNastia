//
//  Extension.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 7/29/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

extension String {

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    func toFloat() -> Float {
        
        return (self as NSString).floatValue
    }
    
    func toSingleSpaceLine () ->String {
        return self.components(separatedBy: " ").filter { !$0.isEmpty }.joined(separator: " ")
    }
    
    func toInt() -> Int {
        return Int((self as NSString).intValue)
    }
    
    func toDouble() -> Double { 
        return (self as NSString).doubleValue
    }
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    func toDate()-> Date? {
        let format : String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
    
}


extension Date{
    // converts to "yyyy-MM-dd" format
    func toStringDefault() -> String {
       
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let fun =  formatter.string(from: self)
        print(fun)
        return fun
    }

    func convertToString(dateformat formatType: DateFormatType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatType.rawValue
        let newDate: String = dateFormatter.string(from: self)
        return newDate
    }
    

}





