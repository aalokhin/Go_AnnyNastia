//
//  DateTextCel.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 8/11/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
import UIKit

enum DateFormatType: String {
    case time = "HH:mm:ss"
    case dateWithTime = "dd-MMM-yyyy  H:mm"
    case date = "dd-MMM-yyyy"
}

class DateTextCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // Reuser identifier
    class func reuseIdentifier() -> String {
        return "DateTextCell"
    }
    
    // Nib name
    class func nibName() -> String {
        return "DateTextCell"
    }
    
    // Cell height
    class func cellHeight() -> CGFloat {
        return 44.0
    }
    
    // Awake from nib method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // Update text
    func updateText(text: String, date: Date) {
        label.text = text
        dateLabel.text = date.convertToString(dateformat: .date)
    }
    
}

