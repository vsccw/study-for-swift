//
//  YL.swift
//  YLQRCodeHelper
//
//  Created by yolo on 2017/2/6.
//  Copyright © 2017年 YOLO. All rights reserved.
//

import Foundation

public extension Bundle {
    /// Create a new Bundle instance for 'Image.xcassets'.
    ///
    /// - Returns: a new bundle which contains 'Image.xcassets'.
    static var currentBundle: Bundle {
        let bundle = Bundle(for: YLQRScanViewController.self)
        if let path = bundle.path(forResource: "YLQRCodeHelper", ofType: "bundle") {
            return Bundle(path: path)!
        } else {
            return bundle
        }
    }
}
