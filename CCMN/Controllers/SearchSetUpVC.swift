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
    func specifyDates(from : Date, to : Date, detailed : Bool)
}



class SearchSetUpVC: UIViewController {
    var str : String?
    var inputTexts: [String] = ["Start date", "End date"]
    var datePickerIndexPath: IndexPath?
    var inputDates: [Date] = []
    var delegate: SetUpDelegate?
    
    var detailed = false
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello here")
        addInitailValues()
        setupVC()
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            print("we want a default date range ")
            detailed = true
        case 1:
            detailed = false
            print("we want a detailed date range")
        default:
            break;
        }
    }
    
    func setupVC() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save(sender:)))
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
    
    @objc func save(sender:UIView){
        print("save button tapped")
        delegate?.specifyDates(from: inputDates[0], to: inputDates[1], detailed : self.detailed)
        navigationController?.popViewController(animated: true)
        
    }
    
}
