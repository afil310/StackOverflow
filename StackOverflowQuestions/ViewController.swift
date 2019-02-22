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
    var soRequest = StackoverflowRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.delegate = self
        loadData(url: soRequest.url)
    }
    
    
    func setupNavigationBar() {
        let settingsBarButtonItem = UIBarButtonItem(image: UIImage(named: "Settings"),
                                                    style: .plain, target: self,
                                                    action: #selector(settingsTapped))
        navigationItem.rightBarButtonItem = settingsBarButtonItem
    }
    
    
    @objc func settingsTapped() {
        let settingsStoryboard = UIStoryboard(name: "Settings", bundle: nil)
//        guard let settingsPage = settingsStoryboard.instantiateViewController(withIdentifier: "SettingsPage") as? SettingsPageController else {
//            return
//        }
        
        guard let settingsPage = settingsStoryboard.instantiateViewController(withIdentifier: "SettingsTable") as? SettingsTableViewController else {
            return
        }
        let navigationController = UINavigationController(rootViewController: settingsPage)
        settingsPage.soRequest = soRequest
        settingsPage.delegate = self
        present(navigationController, animated: true)
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
        for item in response.items {
            print(item.title, item.tags)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let urlString = response?.items[indexPath.row].link else {
            return
        }
        guard let url = URL(string: urlString) else {
            print("Error converting \(urlString) to URL link")
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}


extension ViewController: SettingsTableDelegate {
    func settingsChanged() {
        print("Delegate call: sortBy =", soRequest.sortBy)
        loadData(url: soRequest.url)
    }
}
