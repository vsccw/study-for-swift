enum YLSharePlatform {
    case qq
    case qqZone
    case wechatTimeline
    case wechatSesssion
}

struct YLShareMessage {
    var title: String?
    var thumbImage: UIImage?
    var content: String?
    var url: String?
}

typealias ShareSuccess = () -> Void
typealias ShareFail = (Error?) -> Void

class YLShareManager: NSObject {
    // MARK: - Public property
    static let manager = YLShareManager()
    var success: ShareSuccess?
    var fail: ShareFail?
    
    // MARK: - Private property
    fileprivate override init() {
        super.init()
    }
    
    func share(withPlatform platform: YLSharePlatform, message: YLShareMessage, success: ShareSuccess?, fail: ShareFail?) {
        self.success = success
        self.fail = fail
        
        switch platform {
        case .wechatSesssion:
            let req = wechatUrlMessage(message: message)
            req.scene = Int32(WXSceneSession.rawValue)
            WXApi.send(req)
        case .wechatTimeline:
            let req = wechatUrlMessage(message: message)
            req.scene = Int32(WXSceneTimeline.rawValue)
            WXApi.send(req)
        case .qq:
            let req = qqUrlMessage(message: message)
            let statusCode = QQApiInterface.send(req)
            handleQQStatusCode(statusCode: statusCode)
        case .qqZone:
            let req = qqZoneUrlMessage(message: message)
            let statusCode = QQApiInterface.send(req)
            handleQQStatusCode(statusCode: statusCode)
        }
    }
    
    fileprivate func wechatUrlMessage(message: YLShareMessage) -> SendMessageToWXReq {
        let mediaMsg = WXMediaMessage()
        mediaMsg.title = message.title
        mediaMsg.description = message.content
        mediaMsg.setThumbImage(message.thumbImage)
        
        let webpageObj = WXWebpageObject()
        webpageObj.webpageUrl = message.url
        mediaMsg.mediaObject = webpageObj
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = mediaMsg
        return req
    }
    
    fileprivate func qqUrlMessage(message: YLShareMessage) -> SendMessageToQQReq? {
        if let urlStr = message.url,
            let url = URL(string: urlStr) {
            let obj = QQApiURLObject(url: url, title: message.title, description: message.content, previewImageData: nil, targetContentType: QQApiURLTargetTypeVideo)
            if let image = message.thumbImage {
                let data = UIImageJPEGRepresentation(image, 0.5)
                obj?.previewImageData = data
            }
            obj?.shareDestType = ShareDestTypeQQ
            return SendMessageToQQReq(content: obj)
        }
        else {
            return nil
        }
    }
    
    fileprivate func qqZoneUrlMessage(message: YLShareMessage) -> SendMessageToQQReq? {
        if let urlStr = message.url,
            let url = URL(string: urlStr),
            let image = message.thumbImage {
            let data = UIImageJPEGRepresentation(image, 0.5)
            let urlObj = QQApiNewsObject.object(with: url, title: message.title, description: message.content, previewImageData: data) as? QQApiObject
            urlObj?.cflag = UInt64(kQQAPICtrlFlagQZoneShareOnStart)
            urlObj?.shareDestType = ShareDestTypeQQ
            return SendMessageToQQReq(content: urlObj)
        }
        else {
            return nil
        }
    }
    
    fileprivate func handleQQStatusCode(statusCode: QQApiSendResultCode) {
        if statusCode == EQQAPISENDSUCESS {
            success?()
        }
        else if statusCode == EQQAPIQQNOTINSTALLED {
            let error = YLAuthError(description: "应用未安装", codeType: .appNotInstalled)
            fail?(error)
        }
        else if statusCode == EQQAPIQQNOTSUPPORTAPI {
            let error = YLAuthError(description: "应用不支持", codeType: .versionUnsupport)
            fail?(error)
        }
        else {
            let error = YLAuthError(description: "分享失败", codeType: .unknown)
            fail?(error)
        }
    }
}
