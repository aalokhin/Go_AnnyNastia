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
import SQLite3


///https://gist.github.com/berikv/903ba265e79c634cbeff

/// Calculates a moving average.
/// - Parameter period: the period to calculate averages for.
/// - Warning: the supplied `period` must be larger than 1.
/// - Warning: the supplied `period` should not exceed the collection's `count`.
/// - Returns: a dictionary of indexes and averages.
extension Collection where Element == Int, Index == Int {

func movingAverage(period: Int) -> [Int: Float] {
    precondition(period > 1)
    precondition(count > period)
    let result = (0..<self.count).compactMap { index -> (Int, Float)? in
        if (0..<period).contains(index) { return nil }
        let range = index - period..<index
        let sum = self[range].reduce(0, +)
        let result = Float(sum) / Float(period)
        
        return (index, result)
    }
    return Dictionary(uniqueKeysWithValues: result)
}
}


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
    
    func toDateCustom(format : String)-> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
    
}



extension Date{
    
    func getTimeStamp() -> Int64 {
        return Int64(self.timeIntervalSince1970)
    }
    // converts to "yyyy-MM-dd" format
    func toStringDefault() -> String {
       
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let fun =  formatter.string(from: self)
        //print(fun)
        return fun
    }

    func convertToString(dateformat formatType: DateFormatType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatType.rawValue
        let newDate: String = dateFormatter.string(from: self)
        return newDate
    }
    

    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
    

}

extension UIImage {
    
    func imageOverlayingImages(_ images: [UIImage], scalingBy factors: [CGFloat]? = nil) -> UIImage {
        let size = self.size
        let container = CGRect(x: 0 , y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 2.0)
        UIGraphicsGetCurrentContext()!.interpolationQuality = .high
        
        self.draw(in: container)
        
        let scaleFactors = factors ?? [CGFloat](repeating: 1.0, count: images.count)
        
        for (image, scaleFactor) in zip(images, scaleFactors) {

            let topWidth = size.width / scaleFactor
            let topHeight = size.height / scaleFactor
            let topX = (size.width / 2.0) - (topWidth / 2.0)
            let topY = (size.height / 2.0) - (topHeight / 2.0)
            
            image.draw(in: CGRect(x: 0, y: 0, width: 150, height: 150), blendMode: .normal, alpha: 1.0)
        }
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    func addDots(macs : [Mac], scalingBy factors: [CGFloat]? = nil) -> UIImage {
        let image = UIImage(named: "dot")!
        
        let size = self.size
        let container = CGRect(x: 0 , y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 2.0)
        UIGraphicsGetCurrentContext()!.interpolationQuality = .high
        
        self.draw(in: container)
        
        //let scaleFactors = factors ?? [CGFloat](repeating: 1.0, count: coordinates.count)
        
        for mac in macs{
            image.draw(in: CGRect(x: mac.x, y: mac.y, width: 30, height: 30), blendMode: .normal, alpha: 1.0)
        }
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    func addImageOverlay(x : Double, y : Double, image : UIImage)-> UIImage{
        image.draw(in: CGRect(x: x, y: y, width: 130, height: 130), blendMode: .normal, alpha: 1.0)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    
    
    static func imageByMergingImages(topImage: UIImage, bottomImage: UIImage, scaleForTop: CGFloat = 1.0) -> UIImage {
        let size = bottomImage.size
        let container = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 2.0)
        UIGraphicsGetCurrentContext()!.interpolationQuality = .high
        bottomImage.draw(in: container)
        
        let topWidth = size.width / scaleForTop
        let topHeight = size.height / scaleForTop
        let topX = (size.width / 2.0) - (topWidth / 2.0)
        let topY = (size.height / 2.0) - (topHeight / 2.0)
        
        topImage.draw(in: CGRect(x: topX, y: topY, width: topWidth, height: topHeight), blendMode: .normal, alpha: 1.0)
        
        return UIGraphicsGetImageFromCurrentImageContext()!
    }

    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }

    
}


extension UIViewController {
    func callErrorWithCustomMessage(_ message : String) {
        let alert = UIAlertController(
            title : "Error",
            message : message,
            preferredStyle : UIAlertController.Style.alert
        );
        
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            print("Okay!")
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func logError(timestamp : Int32, ErrorMsg : NSString) {
        var insertStatement: OpaquePointer? = nil
        let insertStatementString = "INSERT INTO ErrorLogTable (Timestamp, Error) VALUES (?, ?);"
        
        // 1
        print(timestamp)
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            // 2
            sqlite3_bind_int(insertStatement, 1, timestamp)
            // 3
            sqlite3_bind_text(insertStatement, 2, ErrorMsg.utf8String, -1, nil)
            
            // 4
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print(ErrorMsg)
                //print(sqlite3_step(insertStatement))
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        // 5
        sqlite3_finalize(insertStatement)
    }
    
    func query() {
       

        
        var queryStatement: OpaquePointer? = nil
        // 1
        let queryStatementString = "SELECT * FROM ErrorLogTable;"
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            // 2
            //print(sqlite3_step(queryStatement))
            if sqlite3_step(queryStatement) == SQLITE_ROW{
                // 3
                let id = sqlite3_column_int(queryStatement, 0)
                
                // 4
                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                let name = String(cString: queryResultCol1!)
                
                // 5
                print("Query Result:")
                print("\(id) | \(name)")
                
            } else {
                print("Query returned no results")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        // 6
        sqlite3_finalize(queryStatement)
    }
}




