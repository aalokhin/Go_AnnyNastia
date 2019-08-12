//
//  NetworkManager.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 8/11/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class NetworkManager {
    
    static func getRequestData(isLocation : Bool, endpoint : String, params : Parameters?, method : HTTPMethod, completion: @escaping (Data?, Error?) -> Void){
        var authHeader : HTTPHeaders
        var urlPath : String
        if isLocation{
            authHeader = ["Authorization" : Client.sharedInstance.locateAuthHeader]
            urlPath = Client.sharedInstance.locateUrl + endpoint
        } else {
            authHeader = ["Authorization" : Client.sharedInstance.presenceAuthHeader]
            urlPath = Client.sharedInstance.presenceUrl + endpoint
        }
        Client.sharedInstance.manager.request(urlPath,
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
    }
    
    
    
    // sets the image given the view, url and the request parameters
    static func getImage(_ urlEndpoint : String, _ parameters : Parameters, completion: @escaping (UIImage?, Error?) -> Void){
        getRequestData(isLocation: true, endpoint : urlEndpoint, params : parameters, method : .get, completion: { data, error in
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
   
    //https://cisco-cmx.unit.ua/api/config/v1/maps/count
}
