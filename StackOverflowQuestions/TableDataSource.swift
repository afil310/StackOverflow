//
//  TableDataSource.swift
//  StackOverflowQuestions
//
//  Created by Andrey Filonov on 28/01/2019.
//  Copyright © 2019 Andrey Filonov. All rights reserved.
//

import UIKit

class TableDataSource: NSObject, UITableViewDataSource {

    private var response: Response?
    private let rowHeight: CGFloat = 104.0
    
    init(response: Response?) {
        self.response = response
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response?.items.count ?? 0
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as! QuestionCell
        guard let question = response?.items[indexPath.row] else {
            return UITableViewCell()
        }
        
        setupCell(cell)
        
        cell.questionTitle.text = question.title
        cell.votesCount.text = String(question.score)
        cell.answersCount.text = String(question.answer_count)
        
        if question.view_count < 1000 {
            cell.viewsCount.text = String(question.view_count)
        } else if question.view_count < 1_000_000 {
            cell.viewsCount.text = String(Int(round(Double(question.view_count)/1000.0))) + "k"
        } else {
            cell.viewsCount.text = String(Int(round(Double(question.view_count)/1000000.0))) + "m"
        }
        
        if question.is_answered {
            cell.answersCount.backgroundColor = UIColor(red: 95/255, green: 186/255, blue: 125/255, alpha: 1.0)
        } else {
            cell.answersCount.backgroundColor = UIColor(red: 0.9333, green: 0.9333, blue: 0.9333, alpha: 1.0)
        }
        
        cell.date.text = int2date(unixdate: question.last_activity_date)
        var tagsText = "|"
        for tag in question.tags {
            tagsText += " " + tag + " |"
        }
        cell.tags.text = tagsText
        
        return cell
    }
    
    
    func setupCell(_ cell: QuestionCell) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 0.5647, green: 0.8196, blue: 0.9765, alpha: 1.0)
        backgroundView.layer.cornerRadius = cell.cellView.frame.height / 10
        
        cell.selectedBackgroundView = backgroundView
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 10
        cell.cellView.layer.backgroundColor = UIColor(red: 0.87, green: 0.95, blue: 0.99, alpha: 1.0).cgColor
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func int2date(unixdate: Int) -> String {
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd.MM.YYYY hh:mm"
        
        let date = NSDate(timeIntervalSince1970: TimeInterval(unixdate))
        return dayTimePeriodFormatter.string(from: date as Date)
    }
}
