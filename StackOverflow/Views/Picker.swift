//
//  Picker.swift
//  StackOverflow
//
//  Created by Andrey Filonov on 09/03/2019.
//  Copyright © 2019 Andrey Filonov. All rights reserved.
//

import UIKit

class Picker: UIPickerView {
    weak var pickerDelegate: PickerDelegate?
    var request: StackoverflowRequest
    var paramName: String
    var numOfComponents = 1
    var componentValues = [String]()
    let parametersDict = [Parameter.sortBy: ["activity", "votes", "creation", "hot", "week", "month"],
                          Parameter.sortOrder: ["asc", "desc"],
                          Parameter.tag: ["None", "Swift", "iOS", "Objective-C"]]
    
    
    init(view: UIView, request: StackoverflowRequest, paramName: String, paramValue: String) {
        self.request = request
        self.paramName = paramName
        super.init(frame: CGRect())
        
        delegate = self
        componentValues = parametersDict[paramName] ?? []
        if let currentValueIndex = componentValues.firstIndex(of: paramValue) {
            selectRow(currentValueIndex, inComponent: 0, animated: true)
        }
        let dummyTextField = UITextField(frame: CGRect.zero)
        view.addSubview(dummyTextField)
        let toolbar = PickerToolbar(dummyTextField)
        toolbar.toolbarDelegate = self
        dummyTextField.inputView = self //a simple way to present UIPickerView at the bottom of the screen like a keyboard, is to attach a picker as the inputView for a dummy 0-sized UITextField
        dummyTextField.becomeFirstResponder()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension Picker: UIPickerViewDelegate, UIPickerViewDataSource, PickerToolbarDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let picker = pickerView as? Picker else {
            return 0
        }
        return picker.componentValues.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let picker = pickerView as? Picker else {
            return nil
        }
        return picker.componentValues[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let picker = pickerView as? Picker else {
            return
        }
        let selectedValue = picker.componentValues[row]
        switch picker.paramName {
        case Parameter.sortBy:
            request.sortBy = selectedValue
        case Parameter.sortOrder:
            request.sortOrder = selectedValue
        case Parameter.tag:
            request.tag = selectedValue != "None" ? selectedValue : ""
        default:
            return
        }
    }
    
    
    func doneChoosingParameter() {
        pickerDelegate?.doneChoosingParameter(request: request)
    }
}


protocol PickerDelegate: AnyObject {
    func doneChoosingParameter(request: StackoverflowRequest)
}
