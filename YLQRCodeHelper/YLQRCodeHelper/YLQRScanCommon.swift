//
//  YLCommon.swift
//  YLQRCode
//
//  Created by yolo on 2017/1/1.
//  Copyright © 2017年 Qiuncheng. All rights reserved.
//

import UIKit
import AudioToolbox

public typealias CompletionHandler<T> = (T) -> Void

extension DispatchQueue {
    static func safeMainQueue(block: @escaping () -> Void) {
        if !Thread.isMainThread {
            DispatchQueue.main.async(execute: block)
        } else {
            block()
        }
    }
}

struct YLQRScanCommon {
    static func playSound() {
        guard let filePath = Bundle.currentBundle.path(forResource: "sound", ofType: "caf") else {
            let alertView = UIAlertView(title: "提醒", message: "找不到音频文件", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "确定")
            alertView.show()
            return
        }
        let soundURL = URL(fileURLWithPath: filePath)
        var soundID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID)
        
        AudioServicesPlaySystemSound(soundID)
        AudioServicesRemoveSystemSoundCompletion(soundID)
    }
}
