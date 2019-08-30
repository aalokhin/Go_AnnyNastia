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
    var unFilteredMacs : [String] = []
    var filteredMacs : [String] = []
    private var customView: UIView!

    
    var allMacs : [Mac] = []
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
        showPopUp()
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
           currentFloor = "735495909441273878"
           allMacs.removeAll()
           unFilteredMacs.removeAll()
           shouldShowSearchResults = false
           searchBar.text = ""
           getAllClients()
          // self.tableView.reloadData()
           print("case 1st floor ")
        case 1:
            print("case 2: second floor")
            allMacs.removeAll()
            unFilteredMacs.removeAll()
            shouldShowSearchResults = false
            searchBar.text = ""
            currentFloor = "735495909441273979"
            getAllClients()
           // self.tableView.reloadData()
        case 2:
            print("case 3: third floor")
            searchBar.text = ""
            shouldShowSearchResults = false
            allMacs.removeAll()
            unFilteredMacs.removeAll()
            currentFloor = "735495909441273980"
            getAllClients()
           // self.tableView.reloadData()
        default:
            break;
        }
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        tableView?.register(UINib(nibName: MacListCell.nibName(), bundle: nil), forCellReuseIdentifier: MacListCell.reuseIdentifier())

        print("HELLO FROM LOCATION VIS VC")
        
        getAllClients()
        
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(checkAll), userInfo: nil, repeats: true)
    



       // getActive()
    }
    
    @objc func checkAll(){
        showPopUp()
        getAllClients()
    }
    
    override func willMove(toParent parent: UIViewController?)
    {
        timer?.invalidate()
        allMacs.removeAll()
        unFilteredMacs.removeAll()
        filteredMacs.removeAll()
        
    }
    
    func updateFloorImg(_ imgURL : String){
       
        NetworkManager.getImage(imgURL, [:] , completion: { image, error in
            if let img = image {
                print("we've got an image")
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
                if let json = try? JSONSerialization.jsonObject(with: d, options: []){
                    //print(json)
                }
               guard let t = try? JSONDecoder().decode([ClientJSON].self, from: d) else {
                    print("error decoding json")
                    return
                }
                
               // var floors : [String] = []
                for one in t{
                    
                    //print(one.mapInfo.floorRefId, one.mapInfo.mapHierarchyString)
//                    if (!floors.contains((one.mapInfo.floorRefId)!)){
//                        floors.append((one.mapInfo.floorRefId)!)
//                    }
                    if let addr = one.macAddress, let x = one.mapCoordinate?.x, let y = one.mapCoordinate?.y {
                        
                        if let refId = one.mapInfo.floorRefId {
                            if refId == self.currentFloor{
                                self.allMacs.append(Mac(x: x, y: y, macAddr: addr))
                                self.unFilteredMacs.append(addr)
                            }
                            
                        }
                        
                    }
                    //one.printAll()
                }
                self.tableView.reloadData()
                if let floor = self.floorsImgs[self.currentFloor]{
                    self.updateFloorImg(floor)
                }
               // print("all floors", floors.count, "\n", floors)
                print("all clients>>>> ", self.unFilteredMacs.count, " all macs>>>>> ", self.allMacs.count)
                
            }
            
        })
    }
    
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
    
    
    
    func showPopUp(){
        var attributes = EKAttributes.topToast
        
        // Set its background to black
        attributes.entryBackground = .color(color: .black)
        
        // Animate in and out using default translation
        attributes.entranceAnimation = .translation
        attributes.exitAnimation = .translation
        attributes.displayDuration = 2
        let customView = UIView(frame: CGRect(x: 100, y: 100, width: view.frame.width, height: 600))
        customView.backgroundColor = .yellow
        SwiftEntryKit.display(entry: customView, using: attributes)
    }
    
    

}

class Mac {
    let x : Double
    let y : Double
    let macAddr : String
    
    init(x: Double, y:Double, macAddr : String) {
        self.x = x
        self.y = y
        self.macAddr = macAddr
    }
}



