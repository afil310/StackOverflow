//
//  HTTPClient.swift
//  StackOverflowQuestions
//
//  Created by Andrey Filonov on 28/01/2019.
//  Copyright © 2019 Andrey Filonov. All rights reserved.
//

import Foundation

class HTTPClient {
    let configuration: URLSessionConfiguration
    let session: URLSession
    var task: URLSessionDataTask?
    private var data: Data?
    weak var delegate: HTTPClientDelegate?
    
    init(url: URL? = nil) {
        configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)
        if url != nil {
            task = session.dataTask(with: url!) {
                (data, response, error) in
                guard let httpResponse = response as? HTTPURLResponse else {
                    return
                }
                print("-----------------------")
                print("HTTP response code:", httpResponse.statusCode)
                print("-----------------------")
                guard let data = data else {
                    print("Downloading error\n", error.debugDescription)
                    return
                }
                self.data = data
                self.delegate?.requestCompleted(data: data)
            }
        }
    }
    
    func request() {
        task?.resume()
    }
}


protocol HTTPClientDelegate: AnyObject {
    func requestCompleted(data: Data)
}
