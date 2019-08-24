//
//  EmptyChartCell.swift
//  CCMN
//
//  Created by ANASTASIA on 8/22/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
import UIKit
//https://stackoverflow.com/questions/32317474/reloading-tableview-data-from-custom-cell
//protocol CustomCellUpdater: class { // the name of the protocol you can put any
//    func updateTableView()
//}

class EmptyChartCell : UITableViewCell {
    
   // weak var delegate: CustomCellUpdater?

    class func reuseIdentifier() -> String {
        return "EmptyChartCell"
    }
    
    // Nib name
    class func nibName() -> String {
        
        return "EmptyChartCell"
    }
    
    // Cell height
    
    
    // Awake from nib method
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
       
        
        super.layoutSubviews()
    }
    
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}

