//
//  DatePicker.swift
//  StackOverflow
//
//  Created by Andrey Filonov on 09/03/2019.
//  Copyright © 2019 Andrey Filonov. All rights reserved.
//

import UIKit

class DatePicker: UIDatePicker {
    weak var pickerDelegate: PickerDelegate?
    var request: StackoverflowRequest
    var paramName: String
    
    
    init(view: UIView, request: StackoverflowRequest, paramName: String, currentDate: Date) {
        self.request = request
        self.paramName = paramName
        super.init(frame: CGRect())
        
        datePickerMode = .date
        maximumDate = paramName == "fromDate" ? Date(timeInterval: -86400, since: Date()) : Date()
        date = currentDate
        let dummyTextField = UITextField(frame: CGRect.zero)
        view.addSubview(dummyTextField)
        let toolbar = PickerToolbar(dummyTextField)
        toolbar.toolbarDelegate = self
        dummyTextField.inputView = self
        dummyTextField.becomeFirstResponder()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension DatePicker: PickerToolbarDelegate {
    func doneChoosingParameter() {
        if paramName == "fromDate" {
            request.fromDate = Int(date.timeIntervalSince1970)
            if request.toDate <= request.fromDate {
                request.toDate = request.fromDate
            }
        } else if paramName == "toDate" {
            request.toDate = Int(date.timeIntervalSince1970)
            if request.fromDate >= request.toDate {
                request.fromDate = request.toDate
            }
        }
        pickerDelegate?.doneChoosingParameter(request: request)
    }
}
