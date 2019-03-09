//
//  SettingsTableController.swift
//  StackOverflow
//
//  Created by Andrey Filonov on 19/02/2019.
//  Copyright © 2019 Andrey Filonov. All rights reserved.
//

import UIKit

class SettingsTableController: UITableViewController {
    
    @IBOutlet weak var sortByTextField: UITextField!
    @IBOutlet weak var sortOrderTextField: UITextField!
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var toDateTextField: UITextField!
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var quotaMaxTextField: UITextField!
    @IBOutlet weak var quotaRemainingTextField: UITextField!
    @IBOutlet weak var appVersionTextField: UITextField!
    
    var soRequest: StackoverflowRequest!
    var soRequestLocalCopy: StackoverflowRequest!
    var quotaMax = 0
    var quotaRemaining = 0
    weak var delegate: SettingsTableDelegate?
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        soRequestLocalCopy = soRequest
        setupNavigationBar()
        setupTableValues()
    }
    
    
    func setupNavigationBar() {
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                target: self, action: #selector(doneButtonTapped))
        navigationItem.leftBarButtonItem = doneBarButtonItem
        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                  target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = cancelBarButtonItem
        navigationItem.title = "Settings"
    }
    
    
    func setupTableValues() {
        sortByTextField.text = soRequestLocalCopy.sortBy
        sortOrderTextField.text = soRequestLocalCopy.sortOrder
        fromDateTextField.text = soRequestLocalCopy.fromDate.convertToDate()
        toDateTextField.text = soRequestLocalCopy.toDate.convertToDate()
        tagTextField.text = soRequestLocalCopy.tag != "" ? soRequestLocalCopy.tag : "None"
        quotaRemainingTextField.text = String(quotaRemaining)
        quotaMaxTextField.text = String(quotaMax)
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            appVersionTextField.text = String(version + " build " + build)
        } else {
            appVersionTextField.text = ""
        }
        
    }
    
    
    @objc func doneButtonTapped() {
        if !(soRequestLocalCopy == soRequest) {
            delegate?.settingsChanged(request: soRequestLocalCopy)
            persistRequestParameters(soRequestLocalCopy: soRequestLocalCopy)
        }
        dismiss(animated: true)
    }
    
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let picker = Picker(view: view, request: soRequestLocalCopy, paramName: Parameter.sortBy, paramValue: soRequestLocalCopy.sortBy)
            picker.pickerDelegate = self
        case 1:
            let picker = Picker(view: view, request: soRequestLocalCopy, paramName: Parameter.sortOrder, paramValue: soRequestLocalCopy.sortOrder)
            picker.pickerDelegate = self
        case 4:
            let picker = Picker(view: view, request: soRequestLocalCopy, paramName: Parameter.tag, paramValue: soRequestLocalCopy.tag)
            picker.pickerDelegate = self
        case 2:
            let fromDate = Date(timeIntervalSince1970: TimeInterval(soRequestLocalCopy.fromDate))
            let picker = DatePicker(view: view, request: soRequestLocalCopy, paramName: Parameter.fromDate, currentDate: fromDate)
            picker.pickerDelegate = self
        case 3:
            let toDate = Date(timeIntervalSince1970: TimeInterval(soRequestLocalCopy.toDate))
            let picker = DatePicker(view: view, request: soRequestLocalCopy, paramName: Parameter.toDate, currentDate: toDate)
            picker.pickerDelegate = self
        default:
            return
        }
    }
    
    
    func persistRequestParameters(soRequestLocalCopy: StackoverflowRequest) {
        let defaults = UserDefaults.standard
//        defaults.set(soRequestLocalCopy.toDate, forKey: "toDate")
//        defaults.set(soRequestLocalCopy.fromDate, forKey: "fromDate")
        defaults.set(soRequestLocalCopy.sortOrder, forKey: "sortOrder")
        defaults.set(soRequestLocalCopy.sortBy, forKey: "sortBy")
        defaults.set(soRequestLocalCopy.tag, forKey: "tag")
    }
}


extension SettingsTableController: PickerDelegate {
    func doneChoosingParameter(request: StackoverflowRequest) {
        soRequestLocalCopy = request
        setupTableValues()
        view.endEditing(true)
    }
}


protocol SettingsTableDelegate: AnyObject {
    func settingsChanged(request: StackoverflowRequest)
}


extension Int {
    func convertToDate() -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "dd-MMM-YYYY"
        return dateFormatter.string(from: date as Date)
    }
}
