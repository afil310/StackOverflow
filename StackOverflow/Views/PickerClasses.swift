//
//  PickerClasses.swift
//  StackOverflow
//
//  Created by Andrey Filonov on 20/02/2019.
//  Copyright © 2019 Andrey Filonov. All rights reserved.
//

import UIKit

class SinglePicker: UIPickerView {
    var numOfComponents = 1
    var parameterName = ""
    var componentValues = [String]()
}


class DatePicker: UIDatePicker {
//    self.datePickerMode = UIDatePicker.Mode.date
//    self.maximumDate: Date? = Date()
    override init(frame: CGRect) {
        super.init(frame: frame)
        datePickerMode = .date
        maximumDate = Date()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
