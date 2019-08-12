//
//  ViewControllerExtensions.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 8/12/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation


extension ViewController : SetUpDelegate {
    func specifyDates(from: Date, to: Date, detailed : Bool) {
        self.startDate = from.toStringDefault()
        self.endDate = to.toStringDefault()
        print("hey frpm delegat here are our dates \(from) and \(to)")
    }
    
    
}
