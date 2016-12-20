//
//  SecondViewController.swift
//  New-Notification-Swift3
//
//  Created by 程庆春 on 2016/12/20.
//  Copyright © 2016年 Qiun Cheng. All rights reserved.
//

import UIKit

let myNotificationKey = "com.qiuncheng.notificationKey"
let myNotificationkeyPassData = "com.qiuncheng.notificationKeyPassData"

class SecondViewController: UIViewController {
    @IBOutlet weak var secondVCLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(doSomething), name: NSNotification.Name(rawValue: myNotificationKey), object: nil)

        // Do any additional setup after loading the view.
    }

    func doSomething() {

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func tapToNotify(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(myNotificationKey), object: self)
        NotificationCenter.default.post(name: Notification.Name(myNotificationKey), object: FirstViewController())
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: myNotificationkeyPassData), object: nil, userInfo: ["name": "qiuncheng"])


        secondVCLabel.text = "Notification compledted!😂 "
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
