import UIKit

enum YLAuthErrorCodeType: Int {
    case userCancelled = -1
    case versionUnsupport = -2
    case authDenied = -3
    case badNetwork = -4
    case unknown = -404
}

struct YLAuthError: Error {
    var description: String
    var codeType: YLAuthErrorCodeType
    init(description: String, codeType: YLAuthErrorCodeType) {
        self.description = description
        self.codeType = codeType
    }
}

struct YLAuthResult {
    var uid: String?
    var openid: String?
    var refreshToken: String?
    var expiration: Date?
    var accessToken: String?
    var wxCode: String?
    var originResponse: Any?
}


typealias SuccessHandler = (YLAuthResult?) -> Void
typealias FailHandler = (Error?) -> Void

class YLAuthManager: NSObject {

    // MARK: - Private property
    fileprivate var loginSuccess: SuccessHandler?
    fileprivate var loginFail: FailHandler?
    fileprivate let permissions = [kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]
    fileprivate var tencentOAth: TencentOAuth?
    
    fileprivate override init() {
        super.init()
    }
    // MARK: - Public property
    
    static let manager = YLAuthManager()
    
    var isWeixinInstalled: Bool {
        return WXApi.isWXAppInstalled()
    }
    
    var isWeiboInstalled: Bool {
        return WeiboSDK.isWeiboAppInstalled()
    }
    
    var isQQInstalled: Bool {
        return QQApiInterface.isQQInstalled()
    }
    
    // MARK: - Public function
    func register(weixinID: String?, qqID: String?, weiboID: String?) {
        WXApi.registerApp(weixinID, enableMTA: false)
        tencentOAth = TencentOAuth(appId: qqID, andDelegate: self)
        tencentOAth?.redirectURI = "www.qq.com"
        tencentOAth?.authShareType = AuthShareType_QQ
        WeiboSDK.enableDebugMode(true)
        WeiboSDK.registerApp(weiboID)
    }
    
    func loginWithQQ(success: SuccessHandler?, fail: FailHandler?) {
        loginSuccess = success
        loginFail = fail
        tencentOAth?.authorize(self.permissions, inSafari: true)
    }
    
    func loginWithWeChat(success: SuccessHandler?, fail: FailHandler?) {
        loginSuccess = success
        loginFail = fail
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = "com.tongzhuogame.wechat.state"
        WXApi.send(req)
    }
    
    func loginWithWeibo(success: SuccessHandler?, fail: FailHandler?) {
        loginSuccess = success
        loginFail = fail
        let request = WBAuthorizeRequest()
        request.redirectURI = "https://www.sina.com"
        // 关于scope说明 http://open.weibo.com/wiki/Scope
        request.scope = "all"
        request.userInfo = ["name": "com.tongzhuogame.weibo.auth"]
        WeiboSDK.send(request)
    }
    
    @available (iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if let sourceApp = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String {
            if sourceApp == "com.tencent.xin" {
                return WXApi.handleOpen(url, delegate: YLAuthManager.manager)
            }
            else if sourceApp == "com.tencent.mqq"{
                return TencentOAuth.handleOpen(url)
            }
            else if sourceApp == "com.sina.weibo" {
                return WeiboSDK.handleOpen(url, delegate: self)
            }
        }
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if sourceApplication == "com.tencent.xin" {
            return WXApi.handleOpen(url, delegate: YLAuthManager.manager)
        }
        else if sourceApplication == "com.tencent.mqq" {
            return TencentOAuth.handleOpen(url)
        }
        else if sourceApplication == "com.sina.weibo" {
            return WeiboSDK.handleOpen(url, delegate: self)
        }
        return true
    }
    
}


// MARK: - WXApiDelegate
extension YLAuthManager: WXApiDelegate {
    func onResp(_ resp: BaseResp!) {
        if resp.errCode == 0 {
            if let authResp = resp as? SendAuthResp {
                if resp.errCode == WXSuccess.rawValue,
                    authResp.state == "com.tongzhuogame.wechat.state" {
                    print(authResp)
                    var result = YLAuthResult()
                    result.wxCode = authResp.code
                    self.loginSuccess?(result)
                }
                else if resp.errCode == WXErrCodeUserCancel.rawValue {
                    let error = YLAuthError(description: "用户取消了登录", codeType: .userCancelled)
                    loginFail?(error)
                }
                else if resp.errCode == WXErrCodeAuthDeny.rawValue {
                    let error = YLAuthError(description: "授权失败", codeType: .authDenied)
                    loginFail?(error)
                }
                else {
                    let error = YLAuthError(description: "授权失败", codeType: .unknown)
                    loginFail?(error)
                }
            }
            else {
                loginSuccess?(nil)
            }
        }
        else {
            loginFail?(YLAuthError(description: resp.errStr ?? "", codeType: YLAuthErrorCodeType(rawValue: Int(resp.errCode)) ?? YLAuthErrorCodeType.unknown))
        }
    }
}


extension YLAuthManager {
    func handleQQStatusCode(statusCode: QQApiSendResultCode) {
        
    }
}

// MARK: - WeiboSDKDelegate
extension YLAuthManager: WeiboSDKDelegate {
    func didReceiveWeiboRequest(_ request: WBBaseRequest!) {
        
    }
    
    func didReceiveWeiboResponse(_ response: WBBaseResponse!) {
        if response.statusCode == WeiboSDKResponseStatusCode.success {
            if let authRes = response as? WBAuthorizeResponse,
                let name = response.requestUserInfo["name"] as? String,
                name == "com.tongzhuogame.weibo.auth" {
                var result = YLAuthResult()
                result.accessToken = authRes.accessToken
                result.refreshToken = authRes.refreshToken
                result.uid = authRes.userID
                result.expiration = authRes.expirationDate
                result.originResponse = authRes.userInfo
                loginSuccess?(result)
            }
        }
        else if response.statusCode == WeiboSDKResponseStatusCode.userCancel {
            let error = YLAuthError(description: "用户取消登录", codeType: .userCancelled)
            loginFail?(error)
        }
        else if response.statusCode == WeiboSDKResponseStatusCode.authDeny {
            let error = YLAuthError(description: "授权失败", codeType: .authDenied)
            loginFail?(error)
        }
        else {
            let error = YLAuthError(description: "授权失败", codeType: .unknown)
            loginFail?(error)
        }
    }
}

// MARK: - TencentSessionDelegate
extension YLAuthManager: TencentSessionDelegate {
    func tencentDidNotNetWork() {
        let error = YLAuthError(description: "网络异常，请重新登录", codeType: .badNetwork)
        loginFail?(error)
    }
    
    func tencentDidLogin() {
        if tencentOAth?.accessToken != nil && !tencentOAth!.accessToken.isEmpty {
            tencentOAth?.getUserInfo()
        }
    }
    
    func tencentDidLogout() {
        
    }
    
    func tencentDidNotLogin(_ cancelled: Bool) {
        if cancelled {
            let error = YLAuthError(description: "用户取消登录", codeType: .userCancelled)
            loginFail?(error)
        }
    }
    
    func getUserInfoResponse(_ response: APIResponse!) {
        var result = YLAuthResult()
        result.accessToken = tencentOAth?.accessToken
        result.expiration = tencentOAth?.expirationDate
        result.openid = tencentOAth?.openId
        result.uid = tencentOAth?.unionid
        result.originResponse = response.jsonResponse
        loginSuccess?(result)
    }
}
