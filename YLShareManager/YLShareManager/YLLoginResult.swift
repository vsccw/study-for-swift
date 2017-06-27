import UIKit

struct YLLoginResult {

    var uid: String?
    var openid: String?
    var refreshToken: String?
    var expiration: Date?
    var accessToken: String?
    
    var originResponse: Any?
}
