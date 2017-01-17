//
//  ViewController.swift
//  WebView
//
//  Created by yolo on 2017/1/4.
//  Copyright © 2017年 Qiuncheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showWKWebView(_ sender: Any) {
        performSegue(withIdentifier: "ShowWKWebView", sender: self)
    }

    @IBAction func showUIWebView(_ sender: Any) {
        performSegue(withIdentifier: "ShowUIWebView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! WebViewController
        if (segue.identifier == "ShowUIWebView") {
            destinationVC.isUIWebView = true
        } else if (segue.identifier == "ShowWKWebView") {
            destinationVC.isUIWebView = false
        }
    }
}

