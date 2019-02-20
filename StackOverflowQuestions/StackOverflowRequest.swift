//
//  StackOverflowURL.swift
//  StackOverflowQuestions
//
//  Created by Andrey Filonov on 28/01/2019.
//  Copyright © 2019 Andrey Filonov. All rights reserved.
//

import Foundation

//   Example: "https://api.stackexchange.com/2.2/questions?fromdate=1548460800&todate=1548547200&order=desc&min=10&sort=votes&site=stackoverflow"

class StackoverflowRequest {
    
    let domain = "https://api.stackexchange.com"
    let version = "2.2"
    let requestType = "questions?"
    var toDate = 0
    var fromDate = 0
    var pageSize = 100
    var sortOrder = "desc"
    var sortBy = "votes"
    var sortMinValue = 10
    var tag = "" //TODO: implement an array of tags
    let site = "stackoverflow"
    
    var url: URL? {
        var urlString = domain + "/" + version + "/" + requestType
        urlString += "pagesize=" + String(pageSize)
        urlString += "&fromdate=" + String(fromDate) + "&todate=" + String(toDate)
        urlString += "&sort=" + sortBy + "&order=" + sortOrder + "&min=" + String(sortMinValue)
        urlString += "&site=" + site
        print("Stackoverflow urlString:", urlString)
        return URL(string: urlString)
    }
    
    init() {
        initRequestParameters()
    }
    
    func initRequestParameters() {
        
        let defaults = UserDefaults.standard
        sortOrder = defaults.string(forKey: "sortOrder") ?? "desc"
        sortBy = defaults.string(forKey: "sortBy") ?? "votes"
        fromDate = defaults.integer(forKey: "fromDate")
        if fromDate == 0 {
            fromDate = toDate - 86400 * 30 //one month ago
        }
        toDate = defaults.integer(forKey: "toDate")
        if toDate == 0 {
            toDate = Int(Date().timeIntervalSince1970) //now
        }
        tag = defaults.string(forKey: "tag") ?? ""
    }
}
