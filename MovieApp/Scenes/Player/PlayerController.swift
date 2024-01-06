//
//  PlayerController.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 05/01/2024.
//

import UIKit
import WebKit

class PlayerController: UIViewController, WKUIDelegate {
    let key: String
    
    private let baseURL = "https://www.youtube.com/embed/"
    private var webView: WKWebView!
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .white
        indicator.startAnimating()
        indicator.isHidden = false
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    init(key: String) {
        self.key = key
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.underPageBackgroundColor = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        if let url = buildUrl() {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loading" {
            if !webView.isLoading {
                DispatchQueue.main.async {
                    self.view = self.webView
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            }
        }
    }
    
    private func buildUrl() -> URL? {
        let urlString = baseURL + key
        let url = URL(string: urlString)
        return url
    }
    
}
