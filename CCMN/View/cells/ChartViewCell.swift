//
//  ChartViewCell.swift
//  CCMN
//
//  Created by ANASTASIA on 8/15/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
import UIKit
import Charts

class ChartViewCell : UITableViewCell{
    
    @IBOutlet weak var barChart: BarChartView!
    
    class func reuseIdentifier() -> String {
        return "ChartViewCell"
    }
    
    // Nib name
    class func nibName() -> String {
        return "ChartViewCell"
    }
    
    // Cell height

    
    // Awake from nib method
    override func awakeFromNib() {
        super.awakeFromNib()
        barChart.noDataText = "You need to provide data for the chart."
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

    
}
