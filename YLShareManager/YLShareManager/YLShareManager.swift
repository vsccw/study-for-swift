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

enum YLShareErrorCodeType: Int {
    case userCancel = -2
    case versionUnsupport = -5
    case uninstalled = 4001
    case wxErrorCommon = -1
    case wxErrCodeSentFail = -3
    case wxErrCodeAuthDeny = -4
    case invalidMsgType = -6
    case sendFailed = -7
    case unknown = 4004
}

struct YLShareError: Error {
    var description: String
    var codeType: YLShareErrorCodeType
    init(description: String, codeType: YLShareErrorCodeType) {
        self.description = description
        self.codeType = codeType
    }
}

enum YLSharePlatformType {
    case line
    case facebook
    case weixinTimeline
    case weixinSession
    case qqSession
    case qqZone
}

typealias Success = ([AnyHashable : Any]?) -> Void
typealias Fail = (Error?) -> Void

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
        if let url = URL(string: "fb://"),
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
    
    // MARK: - Open
    func register(weixinID: String) {
        WXApi.registerApp(weixinID, enableMTA: false)
    }
    
    func register(weixinID: String, qqID: String, weiboID: String) {
        WXApi.registerApp(weixinID, enableMTA: false)
       let _ = TencentOAuth(appId: qqID, andDelegate: nil)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    @available (iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if let sourceApp = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String {
            if sourceApp == "com.tencent.xin" {
                return WXApi.handleOpen(url, delegate: YLShareManager.manager)
            }
            else if sourceApp == "com.tencent.mqq"{
                return TencentOAuth.handleOpen(url)
            }
            else if sourceApp == "com.sina.weibo" {
                
            }
        }
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        return handled
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if sourceApplication == "com.tencent.xin" {
            return WXApi.handleOpen(url, delegate: YLShareManager.manager)
        }
        else if sourceApplication == "com.tencent.mqq" {
            return TencentOAuth.handleOpen(url)
        }
        else if sourceApplication == "com.sina.weibo" {
            return true
        }
        else {
            return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
    }
    
    // MARK: - FBSDKSharingDelegate
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
         fail?(YLShareError(description: "User canceled share.", codeType: YLShareErrorCodeType.userCancel))
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        if error != nil {
            let aErr = error as NSError
            if aErr.code == FBSDKErrorCode.appVersionUnsupportedErrorCode.rawValue {
                fail?(YLShareError(description: "app is out of date", codeType: YLShareErrorCodeType.versionUnsupport))
                return
            }
            fail?(error)
        }
    }
    
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        success?(results)
    }
    
    // MARK: - WXApiDelegate
    func onResp(_ resp: BaseResp!) {
        if resp.errCode == 0 {
            success?(nil)
        }
        else {
            fail?(YLShareError(description: resp.errStr ?? "", codeType: YLShareErrorCodeType(rawValue: Int(resp.errCode)) ?? YLShareErrorCodeType.unknown))
        }
    }
}

extension YLShareManager {
    func handleQQStatusCode(statusCode: QQApiSendResultCode) {
        if statusCode == EQQAPISENDSUCESS {
            success?(nil)
        }
        else if statusCode == EQQAPIMESSAGETYPEINVALID {
            fail?(YLShareError.init(description: "消息类型错误", codeType: .invalidMsgType))
        }
        else if statusCode == EQQAPISENDFAILD {
            fail?(YLShareError(description: "发送失败", codeType: .sendFailed))
        }
    }
}

extension YLShareManager {
    func share(with content: YLShareContent, on platform: YLSharePlatformType, in vc: UIViewController, success: Success? = nil, fail: Fail? = nil) {
        content.showShareView(platform, in: vc, success: success, fail: fail)
    }
}
