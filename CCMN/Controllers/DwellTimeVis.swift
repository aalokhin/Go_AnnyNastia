//
//  DwellTimeVis.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 8/14/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
import UIKit
import Charts

class DwellTimeVis : UIViewController {
    

    override func viewDidLoad() {
        print("hi from vis vc")
        super.viewDidLoad()
        getDwell()
        
       
   
    }
    
    func getDwell(){
        NetworkManager.getRequestData(isLocation: false, endpoint: "api/presence/v1/kpisummary/today?siteId=1513804707441", params: [:], method: .get, completion: {
            data, error in
            if let d = data{
                print("kpisummary/today\n\n")
                
                if let json = try? JSONSerialization.jsonObject(with: d, options: []){
                    print(json)
                }
                

            }
            
        })
        
    }
}
