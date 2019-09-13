//
//  LocationVisVC.swift
//  CCMN
//
//  Created by ANASTASIA on 8/27/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//


//          if let json = try? JSONSerialization.jsonObject(with: d, options: []){
//             print(json)
//          }

import Foundation
import UIKit
import SwiftEntryKit


class  LocationVisVC: UIViewController {
    var shouldShowSearchResults = false
    
    var filteredMacs : [Mac] = []
    var allMacs : [Mac] = []
    var usersSaved  = Set<String>()
    var currUserSet  = Set<String>()
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.register(UINib(nibName: MacListCell.nibName(), bundle: nil), forCellReuseIdentifier: MacListCell.reuseIdentifier())
        print("HELLO FROM LOCATION VIS VC")
        getAllClients()
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(checkAll), userInfo: nil, repeats: true)
    }
    
    @objc func checkAll(){
        filteredMacs.removeAll()
        getAllClients()
    }
    
    func updateTV(_ curFloor : String){
        usersSaved.removeAll()
        searchBar.text = ""
        shouldShowSearchResults = false
        allMacs.removeAll()
        currentFloor = curFloor
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
                let imageTest = img.addDots(macs: self.allMacs)
                self.floorMapImageView.image = imageTest
            }
            else if let err = error{
                self.callErrorWithCustomMessage("Couldn't update image for some reason. Please try again")
                self.logError(timestamp: Int32(Date().getTimeStamp()), ErrorMsg: NSString(string: err.localizedDescription))
            }
        })
    }
    
    func getAllClients(){
        NetworkManager.getRequestData(isLocation: true, endpoint:  "api/location/v2/clients", params: [:], method: .get, completion: {
            data, error in
            if let d = data{
                guard let t = try? JSONDecoder().decode([ClientJSON].self, from: d) else {
                    print("error decoding json")
                    return
                }
                var tempMacs = [Mac]()
                self.currUserSet.removeAll()
                for one in t{
                    if let addr = one.macAddress, let x = one.mapCoordinate?.x, let y = one.mapCoordinate?.y {
                        if let refId = one.mapInfo.floorRefId {
                            if refId == self.currentFloor{
                                self.currUserSet.insert(one.macAddress!)
                                tempMacs.append(Mac(x: x, y: y, macAddr: addr))
                            }
                        }
                        
                    }
                }
                
                let newUser = self.currUserSet.subtracting(self.usersSaved)
                
                //print("cur ->",  self.currUserSet.count, "old ->",  self.usersSaved.count)
                if self.usersSaved.count > 0{
                    
                    
                    for one in newUser{
                        self.showPopUp(newClientMAC : one)
                        print("New: ", one)
                    }
                }
                
                self.usersSaved = self.currUserSet
                self.allMacs = tempMacs
                if let floor = self.floorsImgs[self.currentFloor]{
                    self.updateFloorImg(floor)
                }
                self.tableView.reloadData()
            }
            else if let err = error{
                self.callErrorWithCustomMessage("Couldn't get clients info. Please try again")
                self.logError(timestamp: Int32(Date().getTimeStamp()), ErrorMsg: NSString(string: err.localizedDescription))
            }
            
        })
    }
    
    
    func showPopUp(newClientMAC : String){
        /*                       made by Anny                                      */
        let floors : [String : String] = ["735495909441273878" : "first floor",
                                          "735495909441273979" : "second floor", "735495909441273980" : "third floor"]
        let message : String = " Hi, @xlogin or mac: \(newClientMAC) now is on \(floors[currentFloor] ?? "") "
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/5 - 75, y: self.view.frame.size.height-680, width: self.view.frame.width, height: 300))
        toastLabel.numberOfLines = 0
        toastLabel.backgroundColor = UIColor.blue.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        /*                       made by Anny                                      */
        var attributes = EKAttributes.topToast
        EKAttributes.Precedence.QueueingHeuristic.value = .chronological
        attributes.precedence = .enqueue(priority: .normal)
        attributes.positionConstraints.safeArea = .empty(fillSafeArea: true)
        attributes.entryBackground = .color(color: .black)
        attributes.windowLevel = .normal
        attributes.entranceAnimation = .translation
        attributes.exitAnimation = .translation
        attributes.displayDuration = 1
        SwiftEntryKit.display(entry: toastLabel, using: attributes)
    }
    
    func areEqual(mac1:[Mac], mac2: [Mac]) -> Bool {
        // Don't equal size => false
        
        // sort two arrays
        let array1 = mac1.sorted(by: { $0.macAddr < $1.macAddr })
        let array2 = mac2.sorted(by: { $0.macAddr < $1.macAddr })
        
        if array1.count != array2.count {
            return false
        }
        // get count of the matched items
        let result = zip(array1, array2).enumerated().filter() {
            $1.0.macAddr == $1.1.macAddr
            }.count
        if result == array1.count {
            return true
        }
        return false
    }
    
    
    
}

class Mac : Equatable, Hashable {
    static func == (lhs: Mac, rhs: Mac) -> Bool {
        return lhs.macAddr == rhs.macAddr  && lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    let x : Double
    let y : Double
    let macAddr : String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(macAddr)
        hasher.combine(x)
        hasher.combine(y)
    }
    
    init(x: Double, y:Double, macAddr : String) {
        self.x = x
        self.y = y
        self.macAddr = macAddr
    }
}
