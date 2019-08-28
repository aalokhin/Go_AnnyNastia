//
//  LocationVisVC.swift
//  CCMN
//
//  Created by ANASTASIA on 8/27/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
import UIKit

class  LocationVisVC: UIViewController {
    var shouldShowSearchResults = false
    var unFilteredMacs : [String] = []
    var filteredMacs : [String] = []
    var currentFloor : String = "735495909441273878"

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func SegmentedControlChanged(_ sender: UISegmentedControl) {
        print("segmented contorl clicked")
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
           currentFloor = "735495909441273878"
           unFilteredMacs.removeAll()
           shouldShowSearchResults = false
           searchBar.text = ""
           getAllClients()
          // self.tableView.reloadData()
           print("case 1st floor ")
        case 1:
            print("case 2: second floor")
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
       // getActive()
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
                    print(one.mapInfo.floorRefId, one.mapInfo.mapHierarchyString)
//                    if (!floors.contains((one.mapInfo.floorRefId)!)){
//                        floors.append((one.mapInfo.floorRefId)!)
//                    }
                    if let addr = one.macAddress{
                        if let refId = one.mapInfo.floorRefId {
                            if refId == self.currentFloor{
                                self.unFilteredMacs.append(addr)
                            }
                            
                        }
                        
                    }
                    //one.printAll()
                }
                self.tableView.reloadData()
               // print("all floors", floors.count, "\n", floors)
                print("all clients>>>> ", self.unFilteredMacs.count)
                
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

}
