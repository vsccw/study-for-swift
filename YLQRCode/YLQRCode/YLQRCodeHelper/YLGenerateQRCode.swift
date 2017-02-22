//
//  GenerateQRCode.swift
//  YLQRCode
//
//  Created by yolo on 2017/1/20.
//  Copyright © 2017年 Qiuncheng. All rights reserved.
//

import UIKit
import CoreImage

struct YLGenerateQRCode {
    static func beginGenerate(text: String, withLogo: Bool = false, completion: CompletionHandler<UIImage?>) {
        let strData = text.data(using: .utf8)
        
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter?.setValue(strData, forKey: "inputMessage")
        qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
        
        if let ciImage = qrFilter?.outputImage {
        
            let size = CGSize(width: 260, height: 260)
            let context = CIContext(options: nil)
            var cgImage = context.createCGImage(ciImage, from: ciImage.extent)
            
            UIGraphicsBeginImageContext(size)
            let cgContext = UIGraphicsGetCurrentContext()
            cgContext?.interpolationQuality = .none
            cgContext?.scaleBy(x: 1.0, y: -1.0)
            cgContext?.draw(cgImage!, in: cgContext!.boundingBoxOfClipPath)
            
            if withLogo {
                let image = YLGenerateQRCode.getBorderImage(image: #imageLiteral(resourceName: "29"))
                
                if let podfileCGImage = image?.cgImage {
                    cgContext?.draw(podfileCGImage, in: cgContext!.boundingBoxOfClipPath.insetBy(dx: (size.width - 34.0) * 0.5, dy: (size.height - 34.0) * 0.5))
                }
            }
            let codeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            completion(codeImage)
            cgImage = nil
            return
        }
        completion(nil)
    }
    
    static func getBorderImage(image: UIImage) -> UIImage? {
        
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2.0
        imageView.image = image
        
        var currentImage: UIImage? = nil
        UIGraphicsBeginImageContext(CGSize(width: 34.0, height: 34.0))
        if let context = UIGraphicsGetCurrentContext() {
            imageView.layer.render(in: context)
            currentImage = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return currentImage
    }
}
