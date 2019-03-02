//
//  WebViewController.swift
//  StackOverflow
//
//  Created by Andrey Filonov on 03/03/2019.
//  Copyright © 2019 Andrey Filonov. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var webView = WKWebView()
    var progressView = UIProgressView()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupWebView()
    }
    
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        setupWebView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupWebView()
    }
    
    
    override func viewDidLoad() {
        setupWebView()
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        webView.load(URLRequest(url: URL(string: "about:blank")!))
    }

    
    func setupWebView() {
        progressView.progressTintColor = .red
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.allowsBackForwardNavigationGestures = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(webView)
        view.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2.0),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.alpha = 1.0
            progressView.progress = Float(webView.estimatedProgress)
            if progressView.progress == 1.0 {
                UIView.animate(withDuration: 1.0, animations: {
                    self.progressView.alpha = 0.0
                })
            }
        }
    }
}
