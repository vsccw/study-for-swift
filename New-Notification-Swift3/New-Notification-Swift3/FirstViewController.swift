//
//  ViewController.swift
//  New-Notification-Swift3
//
//  Created by 程庆春 on 2016/12/20.
//  Copyright © 2016年 Qiun Cheng. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var firstVCLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(doSomethingAfterNotified), name: Notification.Name(rawValue: myNotificationKey), object: nil)

        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: myNotificationkeyPassData), object: nil, queue: nil) { [unowned self] (noticification) in
            guard let name = noticification.userInfo?["name"] as? String else { return }
            self.firstVCLabel.text = name
        }
    }
    func doSomethingAfterNotified() {
        print("I have been Notified😀")
        firstVCLabel.text = "Damn, I have been notified😂"
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

