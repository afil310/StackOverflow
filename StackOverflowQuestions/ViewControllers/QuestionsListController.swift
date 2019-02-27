//
//  QuestionsListController.swift
//  StackOverflowQuestions
//
//  Created by Andrey Filonov on 28/01/2019.
//  Copyright © 2019 Andrey Filonov. All rights reserved.
//

import UIKit
import SafariServices

class QuestionsListController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var tableView: UITableView!
    
    var response: Response?
    var tableDataSource: TableDataSource?
    var soRequest = StackoverflowRequest()
    let reachability = Reachability()!
    let networkBar = NetworkBar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupNetworkBar()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.delegate = self
        loadData(url: soRequest.url)
    }
    
    
    @objc func reachabilityChanged(note: Notification) {
        guard let reachability = note.object as? Reachability else {return}
        switch reachability.connection {
        case .wifi, .cellular:
            networkBar.hide(color: UIColor(red: 95/255, green: 186/255, blue: 125/255, alpha: 1.0), message: "Internet is available")
        case .none:
            networkBar.show(color: .red, message: "Internet is not available")
        }
    }
    
    
    func setupNavigationBar() {
        let settingsBarButtonItem = UIBarButtonItem(image: UIImage(named: "Settings"),
                                                    style: .plain, target: self,
                                                    action: #selector(presentSettingsPage))
        navigationItem.rightBarButtonItem = settingsBarButtonItem
        navigationItem.title = "Questions"
    }
    
    
    @objc func presentSettingsPage() {
        let settingsStoryboard = UIStoryboard(name: "Settings", bundle: nil)
        
        guard let settingsPage = settingsStoryboard.instantiateViewController(withIdentifier: "SettingsTable") as? SettingsTableController else {
            return
        }
        let navigationController = UINavigationController(rootViewController: settingsPage)
        settingsPage.soRequest = soRequest
        settingsPage.quotaMax = response?.quota_max ?? 0
        settingsPage.quotaRemaining = response?.quota_remaining ?? 0
        settingsPage.delegate = self
        present(navigationController, animated: true)
    }
    
    
    func loadData(url: URL?) {
        let client = HTTPClient(url: url)
        client.httpClientDelegate = self
        client.request()
    }
    
    
    func decodeResponse(data: Data) {
        do {
            let decoder = JSONDecoder()
            self.response = try decoder.decode(Response.self, from: data)
        } catch let error {
            print("Data decoding error:", error)
        }
    }
    
    
    func setupNetworkBar() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
        networkBar.translatesAutoresizingMaskIntoConstraints = false
        networkBar.isUserInteractionEnabled = false
        view.addSubview(networkBar)
        NSLayoutConstraint.activate([networkBar.widthAnchor.constraint(equalTo: view.widthAnchor),
                                     networkBar.topAnchor.constraint(equalTo: progressView.topAnchor)
            ])
    }
}


extension QuestionsListController: HTTPClientDelegate {
    func requestCompleted(data: Data) {
        decodeResponse(data: data)
        tableDataSource = TableDataSource(response: response)
        tableView.dataSource = tableDataSource
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func dataTaskProgress(progress: Float) {
        progressView.alpha = 1.0
        progressView.progress = progress
        if progress == 1.0 {
            UIView.animate(withDuration: 2.0, animations: {
                self.progressView.alpha = 0.0
            })
        }
    }
}


extension QuestionsListController: UITableViewDelegate {
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


extension QuestionsListController: SettingsTableDelegate {
    func settingsChanged(request: StackoverflowRequest) {
        soRequest = request
        loadData(url: request.url)
    }
}
