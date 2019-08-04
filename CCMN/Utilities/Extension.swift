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
}

extension UIViewController{
    func performRequest(urlPath : String, authHeader : HTTPHeaders?, params : Parameters?, method : HTTPMethod, completion: @escaping (Bool) -> Void){
        
        Client.sharedInstance.manager.request(urlPath, method: .get, parameters : params, headers: authHeader).validate().responseJSON { response in
            switch response.result {
                
            case .success:
                if let value = response.result.value {
                    print(value)
                    print(type(of: response))
                    print("success avg req")
                    completion(true)
                }
            case .failure(let error):
                print("failure avg req")
                print(error)
                completion(false)
            }
        }
    }
    //https://cisco-cmx.unit.ua/api/config/v1/maps/count
    
    
      func performRequestImg(urlPath : String, authHeader : HTTPHeaders?, params : Parameters?, method : HTTPMethod, completion: @escaping (Bool) -> Void){
        
        Client.sharedInstance.manager.request(urlPath, method: .get, headers: authHeader).validate().responseJSON { response in
            switch response.result {
                
            case .success:
               
                
                
                if let value = response.result.value {
                    print(value)
                    print(type(of: response))
                    print("success avg req")
                    completion(true)
                }
            case .failure(let error):
                print("failure avg req")
                print(error)
                completion(false)
            }
        }
    }
}
