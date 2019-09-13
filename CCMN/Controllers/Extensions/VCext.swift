//
//  VCext.swift
//  CCMN
//
//  Created by ANASTASIA on 9/9/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
import UIKit

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelsForStatistics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JustCell", for: indexPath) as! CellForInitialVC
       
        if let text = labelsForStatistics[labelsVsImages[indexPath.row]] {
            cell.lbl.text = text as? String
        } else {
            cell.lbl.text = "loading..."
        }
        cell.img.image = UIImage(named: labelsVsImages[indexPath.row])
        cell.lbl.numberOfLines = 0
        cell.lbl.sizeToFit()
        return cell
    }
    
    
}
