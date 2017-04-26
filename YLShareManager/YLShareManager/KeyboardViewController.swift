//
//  KeyboardViewController.swift
//  YLShareManager
//
//  Created by vsccw on 2017/4/26.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

class KeyboardViewController: UIViewController {
    
    let hiddenTextField = UITextField()
    var v: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 100))
        v.backgroundColor = UIColor.red
        
//        view.addSubview(v)
//        self.v = v
        
        hiddenTextField.frame = CGRect.zero
//        hiddenTextField.inputAccessoryView = v
        view.addSubview(hiddenTextField)
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveKeyboardWillShowNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveKeyboardWillHideNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func receiveKeyboardWillShowNotification(notification: Notification) {
        guard let info = notification.userInfo,
            let frame = info[UIKeyboardFrameEndUserInfoKey] as? CGRect,
        let duration = info[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
//        UIView.animate(withDuration: duration) { 
//            self.v?.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - (frame.height + 100), width: UIScreen.main.bounds.width, height: 100)
//        }
    }
    
    func receiveKeyboardWillHideNotification(notification: Notification) {
        
    }
    
    @IBAction func showKeyboardButtonClicked(_ sender: UIButton) {
        hiddenTextField.becomeFirstResponder()
    }
}
