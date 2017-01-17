//
//  WebViewController.swift
//  WebView
//
//  Created by yolo on 2017/1/4.
//  Copyright © 2017年 Qiuncheng. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var isUIWebView = false
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    lazy var webView: UIWebView =  {
        let webView = UIWebView()
        webView.scalesPageToFit = true
        return webView
    }()
    lazy var wkWebView: WKWebView = {
        let config = WKWebViewConfiguration()
        let webView: WKWebView = WKWebView(frame: CGRect.zero, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        return webView
    }()
    
    @IBOutlet weak var transformButton: UIButton!
    
    var isTransformed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        if isUIWebView {
            view.addSubview(webView)
            webView.frame = view.bounds
            let url = URL(string: "https://vsccw.com")
            let request = URLRequest(url: url!)
            webView.loadRequest(request)
        } else {
            view.insertSubview(wkWebView, at: 0)
            wkWebView.frame = view.bounds
            let url = URL(string: "https://vsccw.com")
            let request = URLRequest(url: url!)
            wkWebView.load(request)
        }
       
        activity.startAnimating()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func transformButtonClicked(_ sender: Any) {

    }
}

extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activity.stopAnimating()
    }
}

extension WebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        return self.wkWebView
    }
    func webViewDidClose(_ webView: WKWebView) {
        
    }
    
}
