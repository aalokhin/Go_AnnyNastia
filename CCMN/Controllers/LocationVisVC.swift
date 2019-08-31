//
//  LocationVisVC.swift
//  CCMN
//
//  Created by ANASTASIA on 8/27/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
import UIKit
import SwiftEntryKit


class  LocationVisVC: UIViewController {
    var shouldShowSearchResults = false
    
    var filteredMacs : [Mac] = []
    var allMacs : [Mac] = []

    private var customView: UIView!

    
    var timer: Timer?
    
    
    var currentFloor : String = "735495909441273878"
    let floorsImgs : [String : String] = ["735495909441273878" : "api/config/v1/maps/image/System%20Campus/UNIT.Factory/1st_Floor",
                                          "735495909441273979" : "api/config/v1/maps/image/System%20Campus/UNIT.Factory/2nd_Floor", "735495909441273980" : "api/config/v1/maps/image/System%20Campus/UNIT.Factory/3rd_Floor"]

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var floorMapImageView: UIImageView!
    
    @IBAction func SegmentedControlChanged(_ sender: UISegmentedControl) {
        print("segmented contorl clicked")
    
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
           updateTV("735495909441273878")
           print("case 1st floor ")
        case 1:
            print("case 2: second floor")
            updateTV("735495909441273979")
        case 2:
            updateTV("735495909441273980")
            print("case 3: third floor")
        default:
            break;
        }
    }
    
    func updateTV(_ curFloor : String){
        searchBar.text = ""
        shouldShowSearchResults = false
        allMacs.removeAll()
        currentFloor = curFloor
        getAllClients()
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        tableView?.register(UINib(nibName: MacListCell.nibName(), bundle: nil), forCellReuseIdentifier: MacListCell.reuseIdentifier())
        print("HELLO FROM LOCATION VIS VC")
        getAllClients()
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(checkAll), userInfo: nil, repeats: true)
        //getActive()
    }
    
    @objc func checkAll(){
       // allMacs.removeAll()
        filteredMacs.removeAll()
        //showPopUp()
        getAllClients()
    }
    
    override func willMove(toParent parent: UIViewController?)
    {
        timer?.invalidate()
        allMacs.removeAll()
        filteredMacs.removeAll()
        
    }
    
    func updateFloorImg(_ imgURL : String){
        NetworkManager.getImage(imgURL, [:] , completion: { image, error in
            if let img = image {
                //print("we've got an image")
                //Client.sharedInstance.floorImgs?.append(img)
               // let test2 = UIImage(named: "dot")!
//                let test3 = test2.resizeImage(targetSize: CGSize(width: 100.0, height: 100.0))
               // let imageTest = img.imageOverlayingImages([test2])
                let imageTest = img.addDots(macs: self.allMacs)
                self.floorMapImageView.image = imageTest
            }
        })
    }
    
    func getAllClients(){
         //https://cisco-cmx.unit.ua/api/location/v2/clients
        NetworkManager.getRequestData(isLocation: true, endpoint:  "api/location/v2/clients", params: [:], method: .get, completion: {
            data, error in
            if let d = data{
//                if let json = try? JSONSerialization.jsonObject(with: d, options: []){
//                    print(json)
//                }
               guard let t = try? JSONDecoder().decode([ClientJSON].self, from: d) else {
                    print("error decoding json")
                    return
                }
                var tempMacs = [Mac]()
                
                for one in t{
                    if let addr = one.macAddress, let x = one.mapCoordinate?.x, let y = one.mapCoordinate?.y {
                        
                        if let refId = one.mapInfo.floorRefId {
                            if refId == self.currentFloor{
                                tempMacs.append(Mac(x: x, y: y, macAddr: addr))
                            }
                        }

                    }
                }
               
                
                let lhsArray = tempMacs.sorted(by: { $0.macAddr < $1.macAddr })
                let rhsArray = self.allMacs.sorted(by: { $0.macAddr < $1.macAddr })
                
//                for one in lhsArray{
//                    print(one.macAddr)
//                }
//                print("--------------")
//                for one  in rhsArray{
//                    print(one.macAddr)
//                    
//                }
//                
                if (lhsArray != rhsArray){
                    print("New user appeared", tempMacs.count, "<- new -- old ->", self.allMacs.count)
                    self.showPopUp()
                }
                
                
                
                self.allMacs = tempMacs
                if let floor = self.floorsImgs[self.currentFloor]{
                    self.updateFloorImg(floor)
                }
                self.tableView.reloadData()
                print(" all macs>>>>> ", self.allMacs.count)
            }
            
        })
    }
    
   
    func showPopUp(){
        var attributes = EKAttributes.topToast
        
        // Set its background to black
        attributes.entryBackground = .color(color: .black)
        
        // Animate in and out using default translation
        attributes.entranceAnimation = .translation
        attributes.exitAnimation = .translation
        attributes.displayDuration = 1
        let customView = UIView(frame: CGRect(x: 100, y: 100, width: view.frame.width, height: 600))
        customView.backgroundColor = .yellow
        SwiftEntryKit.display(entry: customView, using: attributes)
    }
    
    

}

class Mac : Equatable {
    static func == (lhs: Mac, rhs: Mac) -> Bool {
       return lhs.macAddr == rhs.macAddr  && lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    let x : Double
    let y : Double
    let macAddr : String
    
    init(x: Double, y:Double, macAddr : String) {
        self.x = x
        self.y = y
        self.macAddr = macAddr
    }
}



/*

func getActive(){
    ///api/location/v2/clients/active
    NetworkManager.getRequestData(isLocation: true, endpoint:  "api/location/v2/clients/active", params: [:], method: .get, completion: {
        data, error in
        if let d = data{
            if let json = try? JSONSerialization.jsonObject(with: d, options: []){
                print(json)
            }
            guard let t = try? JSONDecoder().decode([String].self, from: d) else {
                print("error decoding json")
                return
            }
            print("active>>>> ", t.count)
            
        }
        
    })
    
}

 */
