//
//  TableDataSource.swift
//  StackOverflow
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
        guard let response = self.response else {
            return 0
        }
        return response.items.count == 0 ? 1 : response.items.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if response?.items.count == 0 {
            let cell = EmptyResultCell()
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as? QuestionCell,
            let question = response?.items[indexPath.row]
        else {
                return UITableViewCell()
        }
        
        cell.setup()
        
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
        
        cell.answersCount.backgroundColor = question.is_answered ?
        UIColor(red: 95/255, green: 186/255, blue: 125/255, alpha: 1.0) :
        UIColor(red: 0.9333, green: 0.9333, blue: 0.9333, alpha: 1.0)
        
        cell.date.text = int2date(unixdate: question.last_activity_date)
        var tagsText = "|"
        for tag in question.tags {
            tagsText += " " + tag + " |"
        }
        cell.tags.text = tagsText
        
        return cell
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


extension String {
    /// Converts HTML string to `String?`
    
    var htmlToString: String? {
        guard let convertedString = try? NSAttributedString(data: Data(utf8),
                                                          options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                                                          documentAttributes: nil)
            else {
                return nil
            }
        return convertedString.string
        
    }
}
