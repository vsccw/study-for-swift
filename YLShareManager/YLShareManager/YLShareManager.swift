//
//  YLShareManager.swift
//  YLShareManager
//
//  Created by vsccw on 2017/4/25.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import FBSDKShareKit
import YLLineKit

enum YLShareErrorType: Int {
    case userCancel = 4001
    case unknown = 4002
}

struct YLShareError: Error {
    var description: String
    var code: YLShareErrorType
    init(description: String, code: YLShareErrorType) {
        self.description = description
        self.code = code
    }
}

typealias Success = ([AnyHashable : Any]) -> Void
typealias Fail = (Error) -> Void

class YLShareManager: NSObject, WXApiDelegate, FBSDKSharingDelegate {
    static let manager = YLShareManager()
    
    var fail: Fail?
    var success: Success?
    
    override init() {
        super.init()
    }
    
    var isLineInstalled: Bool {
        return YLLineKit.isLineInstalled
    }
    
    var isFacebookInstalled: Bool {
        if let url = URL(string: "fbshareextension://"),
         UIApplication.shared.canOpenURL(url) {
            return true
        }
        else {
            return false
        }
    }
    
    var isWeixinInstalled: Bool {
        return WXApi.isWXAppInstalled()
    }
    
    // MARK: - FBSDKSharingDelegate
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
         fail?(YLShareError(description: "User canceled share.", code: YLShareErrorType.userCancel))
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        if error != nil {
            fail?(error)
        }
    }
    
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        success?(results)
    }
    
    // MARK: - WXApiDelegate
    func onReq(_ req: BaseReq!) {
        
    }
    
    func onResp(_ resp: BaseResp!) {
        
    }
}
