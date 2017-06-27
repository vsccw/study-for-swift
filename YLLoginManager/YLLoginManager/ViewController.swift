//
//  ViewController.swift
//  YLLoginManager
//
//  Created by vsccw on 2017/6/27.
//  Copyright © 2017年 YOLO. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func loginWithWXButtonClicked(_ sender: UIButton) {
        YLAuthManager.manager.loginWithWeChat(success: { (result) in
            let alert = UIAlertView(title: "", message: "\(String(describing: result))", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "取消")
            alert.show()
        }) { (error) in
            let alert = UIAlertView(title: "", message: "\(String(describing: error))", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "取消")
            alert.show()
        }
    }
    
    @IBAction func loginWithWBButtonClicked(_ sender: UIButton) {
        YLAuthManager.manager.loginWithWeibo(success: { (result) in
            let alert = UIAlertView(title: "", message: "\(String(describing: result))", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "取消")
            alert.show()
        }) { (error) in
            let alert = UIAlertView(title: "", message: "\(String(describing: error))", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "取消")
            alert.show()
        }
    }
    
    @IBAction func loginWithQQButtonClicked(_ sender: UIButton) {
        YLAuthManager.manager.loginWithQQ(success: { (result) in
            let alert = UIAlertView(title: "", message: "\(String(describing: result))", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "取消")
            alert.show()
        }) { (error) in
            let alert = UIAlertView(title: "", message: "\(String(describing: error))", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "取消")
            alert.show()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

