//
//  DateCell.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 8/11/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
import UIKit

protocol DatePickerDelegate: class {
    func didChangeDate(date: Date, indexPath: IndexPath)
}

class DateCell: UITableViewCell {
    
   // @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var indexPath: IndexPath!
    weak var delegate: DatePickerDelegate?
    
    // Reuser identifier
    class func reuseIdentifier() -> String {
        return "DateCell"
    }
    
    // Nib name
    class func nibName() -> String {
        return "DateCell"
    }
    
    // Cell height
    class func cellHeight() -> CGFloat {
        return 162.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("\n\n-----------awakeFromNib\n\n")
        initView()
        var components = DateComponents()
        components.year = -3
        let minDate = Calendar.current.date(byAdding: components, to: Date())
//        components.year = 10
//        let maxDate = Calendar.current.date(byAdding: components, to: Date())
        
        datePicker.maximumDate = Date()
        datePicker.minimumDate = minDate
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func initView() {
        datePicker.addTarget(self, action: #selector(dateDidChange), for: .valueChanged)
    }
    
    func updateCell(date: Date, indexPath: IndexPath) {
        datePicker.setDate(date, animated: true)
        self.indexPath = indexPath
    }
    
    @objc func dateDidChange(_ sender: UIDatePicker) {
        let indexPathForDisplayDate = IndexPath(row: indexPath.row - 1, section: indexPath.section)
        delegate?.didChangeDate(date: sender.date, indexPath: indexPathForDisplayDate)
    }
    
}
