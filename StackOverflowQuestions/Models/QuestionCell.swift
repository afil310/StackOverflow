//
//  QuestionCell.swift
//  StackOverflowQuestions
//
//  Created by Andrey Filonov on 28/01/2019.
//  Copyright © 2019 Andrey Filonov. All rights reserved.
//

import UIKit

class QuestionCell: UITableViewCell {
    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var votesCount: UILabel!
    @IBOutlet weak var answersCount: UILabel!
    @IBOutlet weak var viewsCount: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var date: UILabel!
}
