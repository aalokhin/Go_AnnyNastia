//
//  ViewController.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 7/28/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    //this shit helps us a  lot
    
    
    @IBOutlet weak var imageMap: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var parameters : Parameters = ["" : ""]
        var urlPath : String = Client.sharedInstance.locateUrl +  locationEndpoints.clientsCount.rawValue
        let auth = Client.sharedInstance.locateAuthHeader
        
        self.performRequest(urlPath : urlPath, authHeader : ["Authorization" : auth], params : parameters, method : .get){ complete in
            if complete {
                print("request completed")
            }
            else {
                print("some error completing task")
            }
        }
        
        //https://cisco-cmx.unit.ua/api/config/v1/maps/image
        
//        parameters = ["date" : "2019/30/06", "username" : "aalokhin"]
//
//
//        self.performRequest(urlPath : "https://cisco-cmx.unit.ua/api/location/v1/historylite/byusername/aalokhin", authHeader : ["Authorization" : auth], params : parameters, method : .get){ complete in
//            if complete {
//                print("request2 completed")
//            }
//            else {
//                print("some error completing request2")
//            }
//        }
        
        

        
        urlPath = Client.sharedInstance.locateUrl + locationEndpoints.firstFloorImg.rawValue
        self.performDataRequest(urlPath : urlPath, authHeader : ["Authorization" : auth], params : parameters, method : .post){ complete in
            if complete {
                print("request2 completed")
            }
            else {
                print("some error completing request2")
            }
        }


    }
    
    func performDataRequest(urlPath : String, authHeader : HTTPHeaders?, params : Parameters?, method : HTTPMethod, completion: @escaping (Bool) -> Void){
        
        Client.sharedInstance.manager.request(urlPath, method: .get, parameters : params, headers: authHeader).validate().responseData { response in
            switch response.result {
                
            case .success:
                print("we successfully compted request with data")
                
                
                if let value = response.result.value {
                    let downloadedImage = UIImage(data: value)
                    self.imageMap.image = downloadedImage
                    print(value)
                    print(type(of: response))
                    print("success data")
                    completion(true)
                }
            case .failure(let error):
                print("failure data")
                print(error)
                completion(false)
            }
        }
    }
    
    
    //IT WORKED FUCKAS!!!!!
    
    
}



/*    _ url: URLConvertible,
 method: HTTPMethod = .get,
 parameters: Parameters? = nil,
 encoding: ParameterEncoding = URLEncoding.default,
 headers: HTTPHeaders? = nil)
 */

