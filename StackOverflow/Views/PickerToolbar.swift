//
//  PickerToolbar.swift
//  StackOverflow
//
//  Created by Andrey Filonov on 09/03/2019.
//  Copyright © 2019 Andrey Filonov. All rights reserved.
//

import UIKit

class PickerToolbar: UIToolbar {
    
    weak var toolbarDelegate: PickerToolbarDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    convenience init(_ textField: UITextField) {
        self.init(frame: CGRect())
        sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneChoosingParameter))
        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        fixedSpace.width = 16.0
        let flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        setItems([fixedSpace, doneButton, flexibleSpace], animated: false)
        isUserInteractionEnabled = true
        textField.inputAccessoryView = self
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func doneChoosingParameter() {
        toolbarDelegate?.doneChoosingParameter()
    }
}


protocol PickerToolbarDelegate: AnyObject {
    func doneChoosingParameter()
}
