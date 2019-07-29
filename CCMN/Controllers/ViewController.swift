//
//  ViewController.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 7/28/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.testRequest()
        // Do any additional setup after loading the view.
    }
    
    func testRequest(){
      //  let urlPath : String = "https://cisco-cmx.unit.ua/api/location/v2/clients/count"
        let auth = String("Basic " + "RO:" + "just4reading").toBase64()
        let queryItems = [ NSURLQueryItem(name: "Authorization", value: auth)]
        let urlComps = NSURLComponents(string: "https://cisco-cmx.unit.ua/api/location/v2/clients/count")!
        urlComps.queryItems = queryItems as [URLQueryItem]
        if let url = urlComps.url{
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            print(url)
            DispatchQueue.global().async{
                let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                    if let err = error {
                        print("error occured \(err)")
                    } else if let d = data
                    {
                       print("some data received")
                    print(d)
                    }
                }
                task.resume()
            }
        }
    }


}
/*
func paramJsonRequest(name: String, dopUrl: String, param: [String:Any], completion: @escaping (Bool) -> Void) {
    let data = requests[name]! //"clientsInfo" : ("https://cisco-cmx.unit.ua/api/location/v2/clients", "just4reading"),
    let auth = "Basic " + String("RO:" + data.password).toBase64()
    Manager.request(data.url + dopUrl, method: .get, parameters: param, headers: ["Authorization": auth]).validate().responseJSON { response in
        switch response.result {
        case .success:
            if let value = response.result.value {
                self.parser.paramParseAll(name: name, timeStamp: MainData.timeStamp, data: value)
                completion(true)
            }
        case .failure(let error):
            self.errors.append(error.localizedDescription + "\n")
            self.writeToFile()
            completion(false)
        }
    }
}
 
 */
