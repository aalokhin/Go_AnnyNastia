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

extension UIImage {
    
    func imageOverlayingImages(_ images: [UIImage], scalingBy factors: [CGFloat]? = nil) -> UIImage {
        let size = self.size
        let container = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 2.0)
        UIGraphicsGetCurrentContext()!.interpolationQuality = .high
        
        self.draw(in: container)
        
        let scaleFactors = factors ?? [CGFloat](repeating: 1.0, count: images.count)
        
        for (image, scaleFactor) in zip(images, scaleFactors) {
            let topWidth = size.width / scaleFactor
            let topHeight = size.height / scaleFactor
            let topX = (size.width / 2.0) - (topWidth / 2.0)
            let topY = (size.height / 2.0) - (topHeight / 2.0)
            
            image.draw(in: CGRect(x: topX, y: topY, width: topWidth, height: topHeight), blendMode: .normal, alpha: 1.0)
        }
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

    
}





