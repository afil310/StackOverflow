//
//  StackOverflowURL.swift
//  StackOverflowQuestions
//
//  Created by Andrey Filonov on 28/01/2019.
//  Copyright © 2019 Andrey Filonov. All rights reserved.
//

import Foundation

//   Example: "https://api.stackexchange.com/2.2/questions?fromdate=1548460800&todate=1548547200&order=desc&min=10&sort=votes&site=stackoverflow"

struct StackoverflowRequest: Equatable {
    
    let domain = "https://api.stackexchange.com"
    let version = "2.2"
    let requestType = "questions?"
    var toDate = 0
    var fromDate = 0
    var pageSize = 100
    var sortOrder = "desc"
    var sortBy = "votes"
//    var sortMinValue = 10
    var tag = "" //TODO: implement an array of tags
    var site = "stackoverflow"
    
    var url: URL? {
        var urlString = domain + "/" + version + "/" + requestType
        urlString += "pagesize=" + String(pageSize)
        urlString += "&fromdate=" + String(fromDate)
        urlString += "&todate=" + String(toDate)
        urlString += "&sort=" + sortBy
        urlString += "&order=" + sortOrder
//        urlString += "&min=" + String(sortMinValue)
        urlString += "&tagged=" + tag
        urlString += "&site=" + site
        print("Stackoverflow urlString:", urlString)
        return URL(string: urlString)
    }
    
    init() {
        initRequestParameters()
    }
    
    mutating func initRequestParameters() {
        
        let defaults = UserDefaults.standard
        sortOrder = defaults.string(forKey: "sortOrder") ?? "desc"
        sortBy = defaults.string(forKey: "sortBy") ?? "votes"
        toDate = defaults.integer(forKey: "toDate")
        if toDate == 0 {
            toDate = Int(Date().timeIntervalSince1970) //now
        }
        fromDate = defaults.integer(forKey: "fromDate")
        if fromDate == 0 {
            fromDate = toDate - 86400 * 30 //one month ago
        }
        tag = defaults.string(forKey: "tag") ?? ""
    }
    
    static func == (larg: StackoverflowRequest, rarg: StackoverflowRequest) -> Bool {
        return  larg.toDate == rarg.toDate &&
            larg.fromDate == rarg.fromDate &&
            larg.pageSize == rarg.pageSize &&
            larg.sortOrder == rarg.sortOrder &&
            larg.sortBy == rarg.sortBy &&
//            larg.sortMinValue == rarg.sortMinValue &&
            larg.tag == rarg.tag &&
            larg.site == rarg.site
    }
}
