//
//  StackOverflowURL.swift
//  StackOverflowQuestions
//
//  Created by Andrey Filonov on 28/01/2019.
//  Copyright © 2019 Andrey Filonov. All rights reserved.
//

import Foundation

//   Example: "https://api.stackexchange.com/2.2/questions?fromdate=1548460800&todate=1548547200&order=desc&min=10&sort=votes&site=stackoverflow"

struct StackoverflowURL {
    let domain = "https://api.stackexchange.com"
    let version = "2.2"
    let requestType = "questions?"
    var todate = Int(Date().timeIntervalSince1970) //now
    var fromdate: Int {
        return todate - 86400 * 30 // One month ago
    }
    var pageSize = 100
    var sortOrder = "desc"
    var sortBy = "votes"
    var sortMinValue = 10
    let site = "stackoverflow"
    
    var url: URL? {
        var urlString = domain + "/" + version + "/" + requestType
        urlString += "pagesize=" + String(pageSize)
        urlString += "&fromdate=" + String(fromdate) + "&todate=" + String(todate)
        urlString += "&sort=" + sortBy + "&order=" + sortOrder + "&min=" + String(sortMinValue)
        urlString += "&site=" + site
        print("Stackoverflow urlString:", urlString)
        return URL(string: urlString)
    }
}
