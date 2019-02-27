//
//  HTTPClient.swift
//  StackOverflowQuestions
//
//  Created by Andrey Filonov on 28/01/2019.
//  Copyright © 2019 Andrey Filonov. All rights reserved.
//

import Foundation

class HTTPClient: NSObject {
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration,
                          delegate: self,
                          delegateQueue: OperationQueue.main)
    }()
    var task: URLSessionDataTask?
    private var data = Data()
    private var expectedContentLength = Int64(0)
    weak var httpClientDelegate: HTTPClientDelegate?
    

    init(url: URL? = nil) {
        super.init()
        if url != nil {
            task = session.dataTask(with: url!)
        }
    }
    
    
    func request() {
        task?.resume()
    }
}


extension HTTPClient: URLSessionDelegate, URLSessionDataDelegate {
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?) {
        httpClientDelegate?.dataTaskProgress(progress: 1.0)
        if error == nil {
            httpClientDelegate?.requestCompleted(data: data)
        } else {
            print("Error getting data from server", error as? String ?? "")
        }
    }
    
    
    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive data: Data) {
        self.data.append(data)
        let progress = Float(self.data.count) / Float(expectedContentLength)
        httpClientDelegate?.dataTaskProgress(progress: progress)
    }
    
    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {

        guard let httpResponse = response as? HTTPURLResponse else {return}
        
        if httpResponse.allHeaderFields["Content-Encoding"] as? String == "gzip" {
            guard let gzippedLength = httpResponse.allHeaderFields["Content-Length"] as? String else {return}
            expectedContentLength = Int64((Int(gzippedLength) ?? 1) * 7) // dirty hack, rough estimation of the real length of unzipped data
        } else {
            expectedContentLength = response.expectedContentLength
        }
        completionHandler(URLSession.ResponseDisposition.allow)
    }
}


protocol HTTPClientDelegate: AnyObject {
    func requestCompleted(data: Data)
    func dataTaskProgress(progress: Float)
}
