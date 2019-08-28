//
//  MacListCell.swift
//  CCMN
//
//  Created by ANASTASIA on 8/28/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
import UIKit

class  MacListCell : UITableViewCell {
    
    // weak var delegate: CustomCellUpdater?
    
    class func reuseIdentifier() -> String {
        return "MacListCell"
    }
    
    // Nib name
    class func nibName() -> String {
        
        return "MacListCell"
    }
    
    // Cell height
    
    
    // Awake from nib method
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}


