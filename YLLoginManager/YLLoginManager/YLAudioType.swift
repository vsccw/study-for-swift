//
//  YLAudioType.swift
//  YLLoginManager
//
//  Created by vsccw on 2017/7/1.
//  Copyright © 2017年 YOLO. All rights reserved.
//

import UIKit
import AudioToolbox

class YLAudioType: NSObject {

    static let manager = YLAudioType()
    
    func audioType(withPath filePath: String) -> UInt32 {
        let pathToFile = filePath as CFString
        let inputFileUrl: CFURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, pathToFile, CFURLPathStyle.cfurlposixPathStyle, false)
        var inputFile: ExtAudioFileRef? = nil
        let err = ExtAudioFileOpenURL(inputFileUrl, &inputFile)
        if err != 0 {
            // handle error
        }
        
        var fileDescription: AudioStreamBasicDescription? = AudioStreamBasicDescription()
        var propertySize = UInt32(MemoryLayout<AudioStreamBasicDescription>.size)
        ExtAudioFileGetProperty(inputFile!, kExtAudioFileProperty_FileDataFormat, &propertySize, &fileDescription)
        
        return fileDescription?.mFormatID ?? 0
    }
    
    func isLinearPCM(withPath filePath: String) -> Bool {
        let type = audioType(withPath: filePath)
        return type == kAudioFormatLinearPCM
    }
    
    func isAAC(withPath filePath: String) -> Bool {
        let type = audioType(withPath: filePath)
        return type == kAudioFormatMPEG4AAC
    }
    
    func isAMR(withPath filePath: String) -> Bool {
        let type = audioType(withPath: filePath)
        return type == kAudioFormatAMR
    }
}
