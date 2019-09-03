//
//  SetUpVCExtnsn.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 8/11/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation
import Alamofire
import UIKit


extension SearchSetUpVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (hourly == false){
            if datePickerIndexPath != nil {
                return inputTexts.count + 1
            } else {
                return inputTexts.count
            }
        }
        else {
            return 3
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (hourly == false){
            //print("we want daily range")
                if datePickerIndexPath == indexPath {
                    let datePickerCell = tableView.dequeueReusableCell(withIdentifier: DateCell.reuseIdentifier()) as! DateCell
                    datePickerCell.updateCell(date: inputDates[indexPath.row - 1], indexPath: indexPath)
                    datePickerCell.delegate = self
                    return datePickerCell
                } else {
                    let dateCell = tableView.dequeueReusableCell(withIdentifier: DateTextCell.reuseIdentifier()) as! DateTextCell
                    dateCell.updateText(text: inputTexts[indexPath.row], date: inputDates[indexPath.row])
                    return dateCell
                }
        } else {
            //print("we want hourly range")
            let cell = tableView.dequeueReusableCell(withIdentifier: MacListCell.reuseIdentifier()) as! MacListCell
            cell.textLabel?.text = dates[indexPath.row]
            return cell
        }
    }
    
}

extension SearchSetUpVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (hourly == false)
        {
            tableView.beginUpdates()
            if let datePickerIndexPath = datePickerIndexPath, datePickerIndexPath.row - 1 == indexPath.row {
                tableView.deleteRows(at: [datePickerIndexPath], with: .fade)
                self.datePickerIndexPath = nil
            } else {
                if let datePickerIndexPath = datePickerIndexPath {
                    tableView.deleteRows(at: [datePickerIndexPath], with: .fade)
                }
                datePickerIndexPath = indexPathToInsertDatePicker(indexPath: indexPath)
                tableView.insertRows(at: [datePickerIndexPath!], with: .fade)
                tableView.deselectRow(at: indexPath, animated: true)
            }
            tableView.endUpdates()
        }
        else
        {
            dateSpan = dates[indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if datePickerIndexPath == indexPath {
            return DateCell.cellHeight()
        } else {
            return DateTextCell.cellHeight()
        }
    }
    
}

extension SearchSetUpVC: DatePickerDelegate {
    
    func didChangeDate(date: Date, indexPath: IndexPath) {
        inputDates[indexPath.row] = date
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
}
