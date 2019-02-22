//
//  SettingsTableTableViewController.swift
//  StackOverflowQuestions
//
//  Created by Andrey Filonov on 19/02/2019.
//  Copyright © 2019 Andrey Filonov. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var sortByTextField: UITextField!
    
    var soRequest: StackoverflowRequest?
    weak var delegate: SettingsTableDelegate?
    
    enum Parameter {
        static let sortBy = "sortBy"
        static let sortOrder = "sortOrder"
        static let fromDate = ""
        static let toDate = ""
        static let tag = "tag"
    }
    
    var parametersDict = [Parameter.sortBy: ["activity", "votes", "creation", "hot", "week", "month"],
                          Parameter.sortOrder: ["asc", "desc"],
                          Parameter.tag: ["None", "Swift", "iOS", "Objective-C"]
        ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
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
    
    
    @objc func doneButtonTapped() {
        delegate?.settingsChanged()
        dismiss(animated: true)
    }
    
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            createPicker(parameterName: Parameter.sortBy, currentValue: soRequest?.sortBy)
        case 1:
            createPicker(parameterName: Parameter.sortOrder, currentValue: soRequest?.sortOrder)
        case 4:
            createPicker(parameterName: Parameter.tag, currentValue: soRequest?.tag)
        case 2, 3:
            //implement date picker here
            return
        default:
            return
        }
    }
    
    
    func createPicker(parameterName: String, currentValue: String?) {
        let picker = SinglePicker()
        picker.parameterName = parameterName
        picker.componentValues = parametersDict[parameterName] ?? []
        if let currentValueIndex = picker.componentValues.index(of: currentValue ?? "") {
            picker.selectRow(currentValueIndex, inComponent: 0, animated: true)
        }
        picker.delegate = self
        
        let dummyTextField = UITextField(frame: CGRect.zero)
        view.addSubview(dummyTextField)
        createPickerToolbar(dummyTextField)
        dummyTextField.inputView = picker //a simple way to present UIPickerView at the bottom of the screen like the keyboard is to attach it as the inputView of a dummy 0-sized UITextField
        dummyTextField.becomeFirstResponder()
    }
    
    
    func createPickerToolbar(_ textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneChoosingParameter))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelChoosingParameter))
        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        fixedSpace.width = 20.0
        let flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton, flexibleSpace, flexibleSpace, cancelButton, flexibleSpace], animated: false)
        toolbar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolbar
    }
    
    
    @objc func doneChoosingParameter() {
        //change lable text in tableview
        delegate?.settingsChanged()
        view.endEditing(true)
    }
    
    
    @objc func cancelChoosingParameter() {
        view.endEditing(true)
    }
}


extension SettingsTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
            soRequest?.sortBy = selectedValue
        case Parameter.sortOrder:
            soRequest?.sortOrder = selectedValue
        case Parameter.tag:
            soRequest?.tag = selectedValue
        case Parameter.fromDate:
//            soRequest?.fromDate = selectedValue
            return
        case Parameter.toDate:
//            soRequest?.toDate = selectedValue
            return
        default:
            return
        }
    }
}


protocol SettingsTableDelegate: AnyObject {
    func settingsChanged()
}
