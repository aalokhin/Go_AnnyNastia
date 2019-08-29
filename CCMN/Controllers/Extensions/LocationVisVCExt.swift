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
            mac = filteredMacs[indexPath.row]
        } else {
            mac = unFilteredMacs[indexPath.row]
        }
        cell.textLabel?.text = mac
       // cell.textLabel?.text = "some tjosn"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults == true  {
            return filteredMacs.count
        }
        return unFilteredMacs.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print(indexPath.row)
        var macName : String
        if shouldShowSearchResults == true {
            macName = filteredMacs[indexPath.row]
        } else {
            macName = unFilteredMacs[indexPath.row]
        }
        print(macName)
        if let index = allMacs.firstIndex(where: { (item) -> Bool in
            item.macAddr == macName   
        }){
             self.floorMapImageView.image = self.floorMapImageView.image?.addImageOverlay(x: allMacs[index].x, y: allMacs[index].y, image: UIImage(named: "redLoc")!)
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
        filteredMacs = unFilteredMacs.filter({( protein : String) -> Bool in
            return protein.lowercased().contains(searchText.lowercased())
        })
        shouldShowSearchResults = searchText != "" ? true : false
        tableView.reloadData()
    }
    
    func setUpSearchBar(){
        searchBar.delegate = self
    }
}

