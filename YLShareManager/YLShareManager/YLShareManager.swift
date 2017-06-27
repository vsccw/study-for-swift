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
    case badNetwork = -8
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

struct YLLoginError: Error {
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
    
    var loginSuccess: ((YLLoginResult) -> Void)?
    var loginFail: Fail?
    
    override init() {
        super.init()
    }
    
    let permissions = [kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]
    var tencentOAth: TencentOAuth?
    
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
    
    var isWeiboInstalled: Bool {
        return WeiboSDK.isWeiboAppInstalled()
    }
    
    // MARK: - Open
    func register(weixinID: String) {
        WXApi.registerApp(weixinID, enableMTA: false)
    }
    
    func register(weixinID: String, qqID: String, weiboID: String) {
        WXApi.registerApp(weixinID, enableMTA: false)
        tencentOAth = TencentOAuth(appId: qqID, andDelegate: self)
        tencentOAth?.redirectURI = "www.qq.com"
        tencentOAth?.authShareType = AuthShareType_QQ
//        WeiboSDK.registerApp(weiboID)
//        WeiboSDK.enableDebugMode(true)
    }
    
    func loginWithQQ() {
        tencentOAth?.authorize(self.permissions, inSafari: true)
    }
    
    func loginWithWeChat() {
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = "tv.yoloyolo.wechat.state"
        WXApi.send(req)
    }
    
    func loginWithWeibo() {
        let request = WBAuthorizeRequest()
        request.redirectURI = "https://www.yoloyolo.tv/"
        request.scope = "all" // 关于scope说明 http://open.weibo.com/wiki/Scope
        request.userInfo = ["name": "tv.yoloyolo.weibo.auth"]
        WeiboSDK.send(request)
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
                return WeiboSDK.handleOpen(url, delegate: self)
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
            return WeiboSDK.handleOpen(url, delegate: self)
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
            if let authResp = resp as? SendAuthResp {
                
                let session = URLSession(configuration: .default)
                if let url = URL(string: "https://api.weixin.qq.com/sns/oauth2/access_token?appid=wxdc1e388c3822c80b&secret=3baf1193c85774b3fd9d18447d76cab0&code=\(authResp.code!)&grant_type=authorization_code") {
                    let request = URLRequest(url: url)
                    session.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
                        do {
                            if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any] {
                                var result = YLLoginResult()
                                result.accessToken = jsonResult["access_token"] as? String
                                result.refreshToken = jsonResult["refresh_token"] as? String
                                result.expiration = Date(timeIntervalSinceNow: (jsonResult["expires_in"] as! TimeInterval))
                                result.openid = jsonResult["openid"] as? String
                                result.uid = jsonResult["unionid"] as? String
                                result.originResponse = jsonResult
                                self?.loginSuccess?(result)
                            }
                        }
                        catch let error {
                            print(error)
                        }
                    }).resume()
                }
        }
            else {
                success?(nil)
            }
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

extension YLShareManager: WeiboSDKDelegate {
    func didReceiveWeiboRequest(_ request: WBBaseRequest!) {
    
    }
    
    func didReceiveWeiboResponse(_ response: WBBaseResponse!) {
        
    }
}

extension YLShareManager: TencentSessionDelegate {
    /**
     * 登录时网络有问题的回调
     */
    func tencentDidNotNetWork() {
        let error = YLLoginError(description: "网络异常，请重新登录", codeType: .badNetwork)
        loginFail?(error)
    }

    func tencentDidLogin() {
        if tencentOAth?.accessToken != nil && !tencentOAth!.accessToken.isEmpty {
            tencentOAth?.getUserInfo()
        }
    }
    
    func tencentDidLogout() {
        print("登出啦")
    }
    
    func tencentDidNotLogin(_ cancelled: Bool) {
        if cancelled {
            let error = YLLoginError(description: "用户取消登录", codeType: .userCancel)
            loginFail?(error)
        }
    }
    
    func getUserInfoResponse(_ response: APIResponse!) {
        
        var result = YLLoginResult()
        result.accessToken = tencentOAth?.accessToken
        result.expiration = tencentOAth?.expirationDate
        result.openid = tencentOAth?.openId
        result.uid = tencentOAth?.unionid
        result.originResponse = response.jsonResponse
        loginSuccess?(result)
    }
}
