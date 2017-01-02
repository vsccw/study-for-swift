//
//  DiapatchQueue+VS.swift
//  new-user-notifications
//
//  Created by 程庆春 on 2017/1/2.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

extension DispatchQueue {
    static func safeMainQueue(excute: @escaping () -> Void) {
        if !Thread.isMainThread {
            DispatchQueue.main.async(execute: excute)
        } else {
            excute()
        }
    }
}
