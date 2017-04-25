//
//  YLLineKit.swift
//  YLShareManager
//
//  Created by vsccw on 2017/4/25.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

public class YLLineKit: NSObject {
    
    public class var isLineInstalled: Bool {
        if let url = URL.init(string: "line://") {
            return UIApplication.shared.canOpenURL(url)
        }
        else {
            return false
        }
    }
    
    public class func sendMessage(message: String) {
        if let str = message.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            let formattedMsg = String.init(format: "line://msg/text/%@", str)
            if let url = URL.init(string: formattedMsg) {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    public class func sendImageMessage(image: UIImage) {
        let pasteboard = UIPasteboard.general
        if let data = UIImageJPEGRepresentation(image, 1.0) {
            pasteboard.setData(data, forPasteboardType: "public.jpeg")
            let formattedMsg = String.init(format: "line://msg/image/%@", pasteboard.name.rawValue)
            if let url = URL.init(string: formattedMsg) {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
