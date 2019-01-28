//
//  ViewController.swift
//  StackOverflowQuestions
//
//  Created by Andrey Filonov on 28/01/2019.
//  Copyright © 2019 Andrey Filonov. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var response: Response?
    var tableDataSource: TableDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.delegate = self
        loadData(url: StackoverflowURL().url)
    }
    
    func loadData(url: URL?) {
        let client = HTTPClient(url: url)
        client.delegate = self
        client.request()
    }
    
    func printServiceInfo() {
        guard let response = self.response else {
            return
        }
        print("---------------------------")
        print("Questions downloaded: \(String(describing: response.items.count))")
        print("Quota: \(String(describing: response.quota_max)), remained: \(String(describing: response.quota_remaining))")
        print("---------------------------")
        for q in response.items {
            print(q.title, q.tags)
        }
    }
    
    func decodeAnswer(data: Data) {
        do {
            let decoder = JSONDecoder()
            self.response = try decoder.decode(Response.self, from: data)
//            printServiceInfo()
        } catch let error {
            print("Data decoding error:", error)
        }
    }
}


extension ViewController: HTTPClientDelegate {
    func requestCompleted(data: Data) {
        decodeAnswer(data: data)
        tableDataSource = TableDataSource(response: response)
        DispatchQueue.main.async {
            self.tableView.dataSource = self.tableDataSource
            self.tableView.reloadData()
        }
    }
}


extension ViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let urlString = response?.items[indexPath.row].link else {
            return
        }
        guard let url = URL(string: urlString) else {
            print("Error converting to URL link", urlString)
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}
