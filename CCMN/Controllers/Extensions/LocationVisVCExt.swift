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
            mac = filteredMacs[indexPath.row].macAddr
        } else {
            mac = allMacs[indexPath.row].macAddr
        }
        cell.textLabel?.text = mac
       // cell.textLabel?.text = "some tjosn"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults == true  {
            return filteredMacs.count
        }
        return allMacs.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print(indexPath.row)
        var macName : String
        if shouldShowSearchResults == true {
            macName = allMacs[indexPath.row].macAddr
        } else {
            macName = allMacs[indexPath.row].macAddr
        }
        print(macName)
        if let index = allMacs.firstIndex(where: { (item) -> Bool in
            item.macAddr == macName
        }){
            if let floor = self.floorsImgs[self.currentFloor]{
                self.updateFloorImg(floor)
                self.floorMapImageView.image = self.floorMapImageView.image?.addImageOverlay(x: allMacs[index].x, y: allMacs[index].y, image: UIImage(named: "redLoc")!)
            }
            
        }
        
        
        /*
         guard let indexPath = tableView.indexPathForSelectedRow else { return }
         let protein : String
         if shouldShowSearchResults == true {
         protein = filteredProteins[indexPath.row]
         } else {
         protein = unFilteredProteins[indexPath.row]
         }
         let destination = segue.destination as! ProteinVisVC
         destination.protein = protein
         */
        //    self.performSegue(withIdentifier: "FromTableView", sender: self)
    }
}





extension LocationVisVC: UISearchBarDelegate {
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        print("here")
        return searchBar.text?.isEmpty ?? true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMacs = allMacs.filter({( protein : Mac) -> Bool in
            return protein.macAddr.lowercased().contains(searchText.lowercased())
        })

        shouldShowSearchResults = searchText != "" ? true : false
        tableView.reloadData()
    }
    
    func setUpSearchBar(){
        searchBar.delegate = self
    }
}

