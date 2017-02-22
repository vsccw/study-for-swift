//
//  YLQRCodeHelper.swift
//  YLQRCodeHelper
//
//  Created by yolo on 2017/2/5.
//  Copyright © 2017年 YOLO. All rights reserved.
//

public func generateQRCode(text: String, withLogo: Bool, completion: CompletionHandler<UIImage?>?) {
    YLGenerateQRCode.beginGenerate(text: text, withLogo: withLogo, completion: completion)
}

public func detectQRCode(image: UIImage, completion: CompletionHandler<String?>?) {
    YLDetectQRCode.scanQRCodeFromPhotoLibrary(image: image, completion: completion)
}
