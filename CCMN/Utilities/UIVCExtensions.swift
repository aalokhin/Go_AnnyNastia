//
//  UIVCExtensions.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 8/8/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

extension UIViewController{
    //perfrms request and returns data as Data
    func getRequestData(urlPath : String, authHeader : HTTPHeaders?, params : Parameters?, method : HTTPMethod, completion: @escaping (Data?, Error?) -> Void){
        
        let request = Client.sharedInstance.manager.request(urlPath,
                                                            method: .get,
                                                            encoding: URLEncoding.default,
                                                            headers: authHeader).validate().responseData { response in
            print("response of the getRequestData status code (if -1 means something is totally wrong)", response.response?.statusCode ?? -1)
            switch response.result {
            case .success:
                if let value = response.result.value {
                  
                    completion(value, nil)
                }
            case .failure(let error):
                print("failure avg req")
                print(error)
                completion(nil, error)
            }
        }
        print(request)
    }
    // sets the image given the view, url and the request parameters
    func getImage(_ url : String, _ parameters : Parameters, completion: @escaping (UIImage?, Error?) -> Void){
        let auth = Client.sharedInstance.locateAuthHeader
        getRequestData(urlPath: url, authHeader : ["Authorization" : auth], params : parameters, method : .get, completion: { data, error in
            if let d =  data {
                if let downloadedImage = UIImage(data:d) {
                    print("request on getting image info completed successfully")
                    completion(downloadedImage, nil)
                }
            } else if let err = error {
                print(err.localizedDescription)
                print("request on getting image info failed")
            }
        })
    }
    
    
    
    
    
    
    
    
    
    
    
    ///this shou,d better be replaced in later versions
    
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
    
    
    
}
