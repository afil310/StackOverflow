//
//  NetworkBar.swift
//  StackOverflow
//
//  Created by Andrey Filonov on 27/02/2019.
//  Copyright © 2019 Andrey Filonov. All rights reserved.
//

import UIKit

class NetworkBar: UIView {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.alpha = 0.0
        self.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .white
        
        self.addSubview(label)
        NSLayoutConstraint.activate([label.widthAnchor.constraint(equalTo: self.widthAnchor),
                                     label.heightAnchor.constraint(equalTo: self.heightAnchor),
                                     label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                     label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    convenience init() {
        let frame = CGRect.zero
        self.init(frame: frame)
    }
    
    
    func show(color: UIColor, message: String) {
        label.text = message
        self.backgroundColor = color
        UIView.animate(withDuration: 1.0) {
            self.alpha = 1.0
        }
    }
    
    
    func hide(color: UIColor, message: String) {
        UIView.animate(withDuration: 2.0, animations: {
            self.backgroundColor = color
            self.label.text = message
        }, completion: { _ in
            UIView.animate(withDuration: 2.0) {
                self.alpha = 0.0
            }
        })
    }
}
