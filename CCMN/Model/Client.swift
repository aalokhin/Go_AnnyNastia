//
//  Client.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 7/29/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation

final class Client {

    static let sharedInstance = Client()
    
    private init(){
        print("Singleton client has been initialized")
    
    }
    
 
}
