//
//  SettingsPageControllerViewController.swift
//  StackOverflowQuestions
//
//  Created by Andrey Filonov on 18/02/2019.
//  Copyright © 2019 Andrey Filonov. All rights reserved.
//

import UIKit

class SettingsPageController: UIViewController {

    @IBOutlet weak var customNavigationItem: UINavigationItem!
    
    var soURL: StackoverflowURL?
    weak var delegate: SettingsPageDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    
    func setupNavigationBar() {
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        customNavigationItem.leftBarButtonItem = doneBarButtonItem
        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        customNavigationItem.rightBarButtonItem = cancelBarButtonItem
    }
    
    
    @objc func doneButtonTapped() {
        delegate?.settingsChanged()
        dismiss(animated: true)
    }
    
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
}


protocol SettingsPageDelegate: AnyObject {
    func settingsChanged()
}
