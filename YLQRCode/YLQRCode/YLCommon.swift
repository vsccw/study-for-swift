//
//  YLCommon.swift
//  YLQRCode
//
//  Created by yolo on 2017/1/1.
//  Copyright © 2017年 Qiuncheng. All rights reserved.
//

import UIKit

extension DispatchQueue {
    static func safeMainQueue(block: @escaping () -> Void) {
        if !Thread.isMainThread {
            DispatchQueue.main.async(execute: block)
        } else {
            block()
        }
    }
}
