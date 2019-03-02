//
//  QuestionsListCell.swift
//  StackOverflow
//
//  Created by Andrey Filonov on 28/01/2019.
//  Copyright © 2019 Andrey Filonov. All rights reserved.
//

import UIKit

class QuestionsListCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class QuestionCell: QuestionsListCell {
    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var votesCount: UILabel!
    @IBOutlet weak var answersCount: UILabel!
    @IBOutlet weak var viewsCount: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var date: UILabel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setup() {
        let selectedBg = UIView()
        selectedBg.backgroundColor = UIColor(red: 0.5647, green: 0.8196, blue: 0.9765, alpha: 1.0)
        selectedBg.layer.cornerRadius = cellView.frame.height / 10
        selectedBackgroundView = selectedBg
        cellView.layer.cornerRadius = cellView.frame.height / 10
        cellView.layer.backgroundColor = UIColor(red: 0.87, green: 0.95, blue: 0.99, alpha: 1.0).cgColor
    }
}


class EmptyResultCell: QuestionsListCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let selectedBg = UIView()
        selectedBg.backgroundColor = UIColor(red: 0.9882, green: 0.7451, blue: 0.6706, alpha: 1.0)
        selectedBackgroundView = selectedBg
        backgroundColor = UIColor(red: 0.9882, green: 0.7451, blue: 0.6706, alpha: 1.0)
        textLabel?.lineBreakMode = .byWordWrapping
        textLabel?.numberOfLines = 5
        textLabel?.text = """
        Your search returned no matches.
        Suggestions:
        ・Try fewer keywords.
        ・Try different keywords.
        ・Try more general keywords.
        """
    }
}
