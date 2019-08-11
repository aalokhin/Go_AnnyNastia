//
//  SeachSetUpVC.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 8/10/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
import UIKit

class SeachSetUpVC: UIViewController {
    var str : String?
    var inputTexts: [String] = ["Start date", "End date", "Another date"]
    var datePickerIndexPath: IndexPath?
    var inputDates: [Date] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello here")
        addInitailValues()
        setupTableView()
    }
    
    func setupTableView() {
        
        
        tableView.register(UINib(nibName: DateTextCell.nibName(), bundle: nil), forCellReuseIdentifier: DateTextCell.reuseIdentifier())
        tableView.register(UINib(nibName: DateCell.nibName(), bundle: nil), forCellReuseIdentifier: DateCell.reuseIdentifier())
        
       
    }
    
    func addInitailValues() {
        inputDates = Array(repeating: Date(), count: inputTexts.count)
    }
    
    func indexPathToInsertDatePicker(indexPath: IndexPath) -> IndexPath {
        if let datePickerIndexPath = datePickerIndexPath, datePickerIndexPath.row < indexPath.row {
            return indexPath
        } else {
            return IndexPath(row: indexPath.row + 1, section: indexPath.section)
        }
    }
}
