//
//  ActivityIndicator.swift
//  StackOverflow
//
//  Created by Andrey Filonov on 10/03/2019.
//  Copyright © 2019 Andrey Filonov. All rights reserved.
//

import UIKit

class ActivityIndicator: UIActivityIndicatorView {
    
    var containerView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    convenience init(view: UIView) {
        self.init(frame: view.frame)
        containerView = view
        setup()
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup() {
        guard let view = containerView else {return}
        style = .whiteLarge
        color = .black
        hidesWhenStopped = true
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        NSLayoutConstraint.activate([topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }
    
}
