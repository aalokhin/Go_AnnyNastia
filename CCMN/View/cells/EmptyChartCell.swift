//
//  EmptyChartCell.swift
//  CCMN
//
//  Created by ANASTASIA on 8/22/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
import UIKit


class EmptyChartCell : UITableViewCell {
    
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
    
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}

