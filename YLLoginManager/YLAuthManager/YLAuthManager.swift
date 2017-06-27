import UIKit

enum YLLoginErrorCodeType: Int {
    case userCancelled = -1
    case versionUnsupport = -2
    case authDenied = -3
    case badNetwork = -4
    case unknown = -404
}

struct YLLoginError: Error {
    var description: String
    var codeType: YLLoginErrorCodeType
    init(description: String, codeType: YLLoginErrorCodeType) {
        self.description = description
        self.codeType = codeType
    }
}

public struct YLAuthResult {
    
    public var uid: String?
    public var openid: String?
    public var refreshToken: String?
    public var expiration: Date?
    public var accessToken: String?
    public var originResponse: Any?
}


public typealias SuccessHandler = (YLAuthResult?) -> Void
public typealias FailHandler = (Error?) -> Void

public class YLAuthManager: NSObject {
    public static let manager = YLAuthManager()
    
    fileprivate var loginSuccess: SuccessHandler?
    fileprivate var loginFail: FailHandler?
    
    fileprivate override init() {
        super.init()
    }
    
    let permissions = [kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]
    var tencentOAth: TencentOAuth?
    
    public var isWeixinInstalled: Bool {
        return WXApi.isWXAppInstalled()
    }
    
    public var isWeiboInstalled: Bool {
        return WeiboSDK.isWeiboAppInstalled()
    }
    
    // MARK: - Open
    
    public func register(weixinID: String?, qqID: String?, weiboID: String?) {
        WXApi.registerApp(weixinID, enableMTA: false)
        tencentOAth = TencentOAuth(appId: qqID, andDelegate: self)
        tencentOAth?.redirectURI = "www.qq.com"
        tencentOAth?.authShareType = AuthShareType_QQ
        WeiboSDK.enableDebugMode(true)
        WeiboSDK.registerApp(weiboID)
    }
    
    public func loginWithQQ(success: SuccessHandler?, fail: FailHandler?) {
        loginSuccess = success
        loginFail = fail
        tencentOAth?.authorize(self.permissions, inSafari: true)
    }
    
    public func loginWithWeChat(success: SuccessHandler?, fail: FailHandler?) {
        loginSuccess = success
        loginFail = fail
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = "tv.yoloyolo.wechat.state"
        WXApi.send(req)
    }
    
    public func loginWithWeibo(success: SuccessHandler?, fail: FailHandler?) {
        loginSuccess = success
        loginFail = fail
        let request = WBAuthorizeRequest()
        request.redirectURI = "https://www.sina.com"
        request.scope = "all" // 关于scope说明 http://open.weibo.com/wiki/Scope
        request.userInfo = ["name": "tv.yoloyolo.weibo.auth"]
        WeiboSDK.send(request)
    }
    
    @available (iOS 9.0, *)
    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
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
    
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
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
extension YLAuthManager: WXApiDelegate {
    // MARK: - WXApiDelegate
    public func onResp(_ resp: BaseResp!) {
        if resp.errCode == 0 {
            if let authResp = resp as? SendAuthResp {
                if resp.errCode == WXSuccess.rawValue {
                    let session = URLSession(configuration: .default)
                    if let url = URL(string: "https://api.weixin.qq.com/sns/oauth2/access_token?appid=wxdc1e388c3822c80b&secret=3baf1193c85774b3fd9d18447d76cab0&code=\(authResp.code!)&grant_type=authorization_code") {
                        let request = URLRequest(url: url)
                        session.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
                            do {
                                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any] {
                                    var result = YLAuthResult()
                                    result.accessToken = jsonResult["access_token"] as? String
                                    result.refreshToken = jsonResult["refresh_token"] as? String
                                    result.expiration = Date(timeIntervalSinceNow: (jsonResult["expires_in"] as! TimeInterval))
                                    result.openid = jsonResult["openid"] as? String
                                    result.uid = jsonResult["unionid"] as? String
                                    result.originResponse = jsonResult
                                    DispatchQueue.main.async {
                                        self?.loginSuccess?(result)
                                    }
                                }
                            }
                            catch let error {
                                self?.loginFail?(error)
                            }
                        }).resume()
                    }
                }
                else if resp.errCode == WXErrCodeUserCancel.rawValue {
                    let error = YLLoginError(description: "用户取消了登录", codeType: .userCancelled)
                    loginFail?(error)
                }
                else if resp.errCode == WXErrCodeAuthDeny.rawValue {
                    let error = YLLoginError(description: "授权失败", codeType: .authDenied)
                    loginFail?(error)
                }
                else {
                    let error = YLLoginError(description: "授权失败", codeType: .unknown)
                    loginFail?(error)
                }
            }
            else {
                loginSuccess?(nil)
            }
        }
        else {
            loginFail?(YLLoginError(description: resp.errStr ?? "", codeType: YLLoginErrorCodeType(rawValue: Int(resp.errCode)) ?? YLLoginErrorCodeType.unknown))
        }
    }
}

extension YLAuthManager {
    func handleQQStatusCode(statusCode: QQApiSendResultCode) {
        
    }
}

extension YLAuthManager: WeiboSDKDelegate {
    public func didReceiveWeiboRequest(_ request: WBBaseRequest!) {
        
    }
    
    public func didReceiveWeiboResponse(_ response: WBBaseResponse!) {
        
        if response.statusCode == WeiboSDKResponseStatusCode.success {
            if let authRes = response as? WBAuthorizeResponse {
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
            let error = YLLoginError(description: "用户取消登录", codeType: .userCancelled)
            loginFail?(error)
        }
        else if response.statusCode == WeiboSDKResponseStatusCode.authDeny {
            let error = YLLoginError(description: "授权失败", codeType: .authDenied)
            loginFail?(error)
        }
        else {
            let error = YLLoginError(description: "授权失败", codeType: .unknown)
            loginFail?(error)
        }
    }
}

extension YLAuthManager: TencentSessionDelegate {
    public func tencentDidNotNetWork() {
        let error = YLLoginError(description: "网络异常，请重新登录", codeType: .badNetwork)
        loginFail?(error)
    }
    
    public func tencentDidLogin() {
        if tencentOAth?.accessToken != nil && !tencentOAth!.accessToken.isEmpty {
            tencentOAth?.getUserInfo()
        }
    }
    
    public func tencentDidLogout() {
        print("登出啦")
    }
    
    public func tencentDidNotLogin(_ cancelled: Bool) {
        if cancelled {
            let error = YLLoginError(description: "用户取消登录", codeType: .userCancelled)
            loginFail?(error)
        }
    }
    
    public func getUserInfoResponse(_ response: APIResponse!) {
        
        var result = YLAuthResult()
        result.accessToken = tencentOAth?.accessToken
        result.expiration = tencentOAth?.expirationDate
        result.openid = tencentOAth?.openId
        result.uid = tencentOAth?.unionid
        result.originResponse = response.jsonResponse
        loginSuccess?(result)
    }
}
