//
//  LocationVisVCExt.swift
//  CCMN
//
//  Created by ANASTASIA on 8/28/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
import UIKit

extension  LocationVisVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MacListCell.reuseIdentifier()) as! MacListCell
        
        let mac : String
        if shouldShowSearchResults == true {
            if (indexPath.row < filteredMacs.count){
                 mac = filteredMacs[indexPath.row].macAddr
            }
            else {
                print("index out of range here")
                mac = "...loading"
                
            }
          
        } else {
            if (indexPath.row < self.allMacs.count){
                mac = allMacs[indexPath.row].macAddr
            }
             else {
                print("index out of range here")
                mac = "...loading"
                
            }
        }
        cell.textLabel?.text = mac
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults == true  {
            return filteredMacs.count
        }
        return allMacs.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        var macName = ""
        
        //need to fix out of range here!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        if shouldShowSearchResults == true {
            if (indexPath.row < filteredMacs.count){
                macName = filteredMacs[indexPath.row].macAddr
            }
            else {
                print("index out of range here")
                print("filtered macs : ", self.filteredMacs.count, "   <->   ", indexPath.row )
                return
            }
        } else {
            if (indexPath.row < self.allMacs.count){
                macName = self.allMacs[indexPath.row].macAddr
            }
            else {
                print("index out of range here")
                print("all macs : ", self.allMacs.count, "   <->   ", indexPath.row )
                return
                
            }
        }
        
        if let index = allMacs.firstIndex(where: { (item) -> Bool in
            item.macAddr == macName
        }){
            if let floor = self.floorsImgs[self.currentFloor]{
                self.updateFloorImg(floor)
                self.floorMapImageView.image = self.floorMapImageView.image?.addImageOverlay(x: allMacs[index].x, y: allMacs[index].y, image: UIImage(named: "redLoc")!)
            }
            
        }
    }
}





extension LocationVisVC: UISearchBarDelegate {
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        print("here")
        return searchBar.text?.isEmpty ?? true
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("invalidating timer")
        timer?.invalidate()
        filteredMacs = allMacs.filter({( protein : Mac) -> Bool in
            return protein.macAddr.lowercased().contains(searchText.lowercased())
        })
        
        shouldShowSearchResults = searchText != "" ? true : false
        if (shouldShowSearchResults == false){
            print("timer restarted")
            timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(checkAll), userInfo: nil, repeats: true)
        }
        tableView.reloadData()
    }
    
    
    func setUpSearchBar(){
        searchBar.delegate = self
    }
    
    
}
