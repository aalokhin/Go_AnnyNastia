//
//  SearchSetUpVC.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 8/10/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
import UIKit

protocol SetUpDelegate {
    func specifyDates(from : Date, to : Date, hourly : Bool, dateSpan : String?)
}



class SearchSetUpVC: UIViewController {
    var str : String?
    let dates : [String] = ["today", "yesterday"]
    
    var inputTexts: [String] = ["Start date", "End date"]
    var datePickerIndexPath: IndexPath?
    var inputDates: [Date] = []
    var delegate: SetUpDelegate?
    
    var hourly = true
    var dateSpan = "today"
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVCForDatePickUp()
        
        print("hello here")
        addInitailValues()
        setupVCForDatePickUp()
    }
    
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            print("we want a hourly date range ")
            hourly = true
            self.tableView.reloadData()
        // self.tableView.isHidden = true
        case 1:
            hourly = false
            
            addInitailValues()
            
            print("we want a daily date range")
            self.tableView.reloadData()
        //self.tableView.isHidden = false
        default:
            break;
        }
    }
    
    func setupVCForDatePickUp() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save(sender:)))
        tableView.register(UINib(nibName: DateTextCell.nibName(), bundle: nil), forCellReuseIdentifier: DateTextCell.reuseIdentifier())
        tableView.register(UINib(nibName: DateCell.nibName(), bundle: nil), forCellReuseIdentifier: DateCell.reuseIdentifier())
        tableView.register(UINib(nibName: MacListCell.nibName(), bundle: nil), forCellReuseIdentifier: MacListCell.reuseIdentifier())
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
    
    @objc func save(sender:UIView){
        print("save button tapped")
        if inputDates[0] > inputDates[1]{
            addInitailValues()
            callErrorWithCustomMessage("Please make sure the start date is before the end date")
            return
        }
        delegate?.specifyDates(from: inputDates[0], to: inputDates[1], hourly : self.hourly, dateSpan: self.dateSpan)
        navigationController?.popViewController(animated: true)
        
    }
    
}
