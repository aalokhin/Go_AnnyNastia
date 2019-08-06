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
        let parameters : Parameters = ["" : ""]
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
        
        urlPath = Client.sharedInstance.locateUrl + locationEndpoints.allFloors.rawValue
       
        //getting the floors information
        getRequestData(urlPath: urlPath, authHeader : ["Authorization" : auth], params : parameters, method : .get, completion: { data, error in
                if let d =  data{
                    print("request on getting maps info completed")
                   // print(d)
                    // let json = try? JSONSerialization.jsonObject(with: d, options: [])
                   // print(json ?? "serialization of json failed")
                    
                    let decoder = JSONDecoder()
                    guard let t = try? decoder.decode(mapJSON.self, from: d) else {
                        print("error decoding json")
                        return
                    }
                    print(t.campusCounts?.count ?? "no campus counts")
                }
            })
           
        }

    
    
    //IT WORKED FUCKAS!!!!!
    
    
    
    
//    func performDataRequest(urlPath : String, authHeader : HTTPHeaders?, params : Parameters?, method : HTTPMethod, completion: @escaping (Bool) -> Void){
//
//
//        Client.sharedInstance.manager.request(urlPath, method: .get, parameters : params, headers: authHeader).validate().responseData { response in
//            switch response.result {
//
//            case .success:
//                print("we successfully completed request with data")
//
//
//                if let value = response.result.value {
//                    let downloadedImage = UIImage(data: value)
//                    self.imageMap.image = downloadedImage
//                    print(value)
//                    print(type(of: response))
//                    print("success data")
//                    completion(true)
//                }
//            case .failure(let error):
//                print("failure data")
//                print(error)
//                completion(false)
//            }
//        }
//    }

    
    
}



/*    _ url: URLConvertible,
 method: HTTPMethod = .get,
 parameters: Parameters? = nil,
 encoding: ParameterEncoding = URLEncoding.default,
 headers: HTTPHeaders? = nil)
 */





// get the floor info




//  "floorInfo" : ("https://cisco-cmx.unit.ua/api/config/v1/maps/count", "just4reading"),

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


// parameters = ["campusName" : "System Campus", "buildingName" : "UNIT.Factory", "floorName" : "1st_Floor"]



