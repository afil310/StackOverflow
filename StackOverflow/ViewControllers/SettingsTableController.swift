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
    
    
    var soRequest = StackoverflowRequest()
    var soRequestLocalCopy = StackoverflowRequest()
    var quotaMax = 0
    var quotaRemaining = 0
    weak var delegate: SettingsTableDelegate?
    var fromDatePicker: UIDatePicker?
    var toDatePicker: UIDatePicker?
    
    enum Parameter {
        static let sortBy = "sortBy"
        static let sortOrder = "sortOrder"
        static let fromDate = "fromDate"
        static let toDate = "toDate"
        static let tag = "tag"
    }
    
    var parametersDict = [Parameter.sortBy: ["activity", "votes", "creation", "hot", "week", "month"],
                          Parameter.sortOrder: ["asc", "desc"],
                          Parameter.tag: ["None", "Swift", "iOS", "Objective-C"]
        ]
    
    
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
            createPicker(parameterName: Parameter.sortBy, currentValue: soRequestLocalCopy.sortBy)
        case 1:
            createPicker(parameterName: Parameter.sortOrder, currentValue: soRequestLocalCopy.sortOrder)
        case 4:
            createPicker(parameterName: Parameter.tag, currentValue: soRequestLocalCopy.tag)
        case 2:
            let fromDate = Date(timeIntervalSince1970: TimeInterval(soRequestLocalCopy.fromDate))
            createDatePicker(parameterName: Parameter.fromDate, currentValue: fromDate)
        case 3:
            let toDate = Date(timeIntervalSince1970: TimeInterval(soRequestLocalCopy.toDate))
            createDatePicker(parameterName: Parameter.toDate, currentValue: toDate)
        default:
            return
        }
    }
    
    
    func createPicker(parameterName: String, currentValue: String?) {
        let picker = SinglePicker()
        picker.delegate = self
        picker.parameterName = parameterName
        picker.componentValues = parametersDict[parameterName] ?? []
        if let currentValueIndex = picker.componentValues.firstIndex(of: currentValue ?? "") {
            picker.selectRow(currentValueIndex, inComponent: 0, animated: true)
        }
        let dummyTextField = UITextField(frame: CGRect.zero)
        view.addSubview(dummyTextField)
        createPickerToolbar(dummyTextField)
        dummyTextField.inputView = picker //a simple way to present UIPickerView at the bottom of the screen like a keyboard, is to attach a picker as the inputView for a dummy 0-sized UITextField
        dummyTextField.becomeFirstResponder()
    }
    
    
    func createDatePicker(parameterName: String, currentValue: Date) {
        let picker = DatePicker()
        picker.date = currentValue
        if parameterName == Parameter.fromDate {
            fromDatePicker = picker
        } else {
            toDatePicker = picker
        }
        let dummyTextField = UITextField(frame: CGRect.zero)
        view.addSubview(dummyTextField)
        createPickerToolbar(dummyTextField)
        dummyTextField.inputView = picker
        dummyTextField.becomeFirstResponder()
    }
    
    func createPickerToolbar(_ textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneChoosingParameter))
        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        fixedSpace.width = 16.0
        let flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([fixedSpace, doneButton, flexibleSpace], animated: false)
        toolbar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolbar
    }
    
    
    @objc func doneChoosingParameter() {
        if fromDatePicker != nil {
            soRequestLocalCopy.fromDate = Int(fromDatePicker!.date.timeIntervalSince1970)
            if soRequestLocalCopy.toDate <= soRequestLocalCopy.fromDate {
                soRequestLocalCopy.toDate = soRequestLocalCopy.fromDate
            }
        }
        if toDatePicker != nil {
            soRequestLocalCopy.toDate = Int(toDatePicker!.date.timeIntervalSince1970)
            if soRequestLocalCopy.fromDate >= soRequestLocalCopy.toDate {
                soRequestLocalCopy.fromDate = soRequestLocalCopy.toDate
            }
        }

        setupTableValues()
        view.endEditing(true)
        fromDatePicker = nil
        toDatePicker = nil
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


extension SettingsTableController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let picker = pickerView as? SinglePicker else {
            return 0
        }
        return picker.componentValues.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let picker = pickerView as? SinglePicker else {
            return nil
        }
        return picker.componentValues[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let picker = pickerView as? SinglePicker else {
            return
        }
        let selectedValue = picker.componentValues[row]
        switch picker.parameterName {
        case Parameter.sortBy:
            soRequestLocalCopy.sortBy = selectedValue
        case Parameter.sortOrder:
            soRequestLocalCopy.sortOrder = selectedValue
        case Parameter.tag:
            soRequestLocalCopy.tag = selectedValue != "None" ? selectedValue : ""
        default:
            return
        }
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
