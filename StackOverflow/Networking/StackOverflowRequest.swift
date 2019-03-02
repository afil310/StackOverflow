//
//  StackOverflowRequest.swift
//  StackOverflow
//
//  Created by Andrey Filonov on 28/01/2019.
//  Copyright © 2019 Andrey Filonov. All rights reserved.
//

import Foundation

//   Example: "https://api.stackexchange.com/2.2/questions?fromdate=1548460800&todate=1548547200&order=desc&min=10&sort=votes&site=stackoverflow"

struct StackoverflowRequest: Equatable {
    
    let domain = "https://api.stackexchange.com"
    let version = "2.2"
    let questionsRequest = "questions?"
    let searchRequest = "search/advanced?"
    var toDate = 0
    var fromDate = 0
    var pageSize = 100
    var sortOrder = "desc"
    var sortBy = "votes"
//    var sortMinValue = 10
    var tag = "" //TODO: implement an array of tags
    var site = "stackoverflow"
    var query = ""
    
    var url: URL? {
        let requestType = query == "" ? questionsRequest : searchRequest
        var urlString = domain + "/" + version + "/" + requestType
        urlString += "pagesize=" + String(pageSize)
        urlString += "&fromdate=" + String(fromDate)
        urlString += "&todate=" + String(toDate)
        urlString += "&sort=" + sortBy
        urlString += "&order=" + sortOrder
//        urlString += "&min=" + String(sortMinValue)
        urlString += "&tagged=" + tag
        urlString += "&q=" + query
        urlString += "&site=" + site
        print("Stackoverflow urlString:", urlString)
        return URL(string: urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? "")
    }
    
    init() {
        initRequestParameters()
    }
    
    mutating func initRequestParameters() {
        let defaults = UserDefaults.standard
        sortOrder = defaults.string(forKey: "sortOrder") ?? "desc"
        sortBy = defaults.string(forKey: "sortBy") ?? "votes"
        toDate = Int(Date().timeIntervalSince1970) //now
        fromDate = toDate - 86400 * 7 //one week ago
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
