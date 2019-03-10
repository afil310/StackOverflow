//
//  HTTPClient.swift
//  StackOverflow
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
    private var dataReceived = Data()
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


func decodeResponse(data: Data) -> Response? {
    var decodedResponse: Response?
    do {
        let decoder = JSONDecoder()
        decodedResponse = try decoder.decode(Response.self, from: data)
    } catch let error {
        print("Response decoding error:", error)
        print("Received response:", String(data: data, encoding: .utf8)!)
        return nil
    }
    return decodedResponse
}


extension HTTPClient: URLSessionDelegate, URLSessionDataDelegate {
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?) {
        httpClientDelegate?.dataTaskProgress(progress: 1.0)
        if error == nil {
            if let response = decodeResponse(data: dataReceived) {
                for itm in 0..<response.items.count {
                    response.items[itm].title = response.items[itm].title.htmlToString ?? response.items[itm].title
                }
                httpClientDelegate?.requestCompleted(response: response)
            }
        } else {
            print("Error getting data from server", error as? String ?? "")
        }
    }
    
    
    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive data: Data) {
        self.dataReceived.append(data)
        let progress = Float(self.dataReceived.count) / Float(expectedContentLength)
        httpClientDelegate?.dataTaskProgress(progress: progress)
    }
    
    
    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {

        guard let httpResponse = response as? HTTPURLResponse else {return}
        print("Server response code:", httpResponse.statusCode)
        if httpResponse.allHeaderFields["Content-Encoding"] as? String == "gzip" {
            guard let gzippedLength = httpResponse.allHeaderFields["Content-Length"] as? String else {return}
            expectedContentLength = Int64((Int(gzippedLength) ?? 1) * 7) // a dirty hack, rough upper estimation of the real length of unzipped data
        } else {
            expectedContentLength = response.expectedContentLength
        }
        completionHandler(URLSession.ResponseDisposition.allow)
    }
}


protocol HTTPClientDelegate: AnyObject {
    func requestCompleted(response: Response?)
    func dataTaskProgress(progress: Float)
}
