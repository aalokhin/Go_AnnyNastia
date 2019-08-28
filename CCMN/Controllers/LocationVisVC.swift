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

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func SegmentedControlChanged(_ sender: UISegmentedControl) {
        print("segmented contorl clicked")
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        tableView?.register(UINib(nibName: MacListCell.nibName(), bundle: nil), forCellReuseIdentifier: MacListCell.reuseIdentifier())

        print("HELLO FROM LOCATION VIS VC")
        
        getAllClients()
        getActive()
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
                for one in t{
                    if let addr = one.macAddress{
                        self.unFilteredMacs.append(addr)
                        
                    }
                    //one.printAll()
                }
                self.tableView.reloadData()
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
