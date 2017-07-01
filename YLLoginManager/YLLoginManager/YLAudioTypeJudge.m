//
//  YLAudioTypeJudge.m
//  YLLoginManager
//
//  Created by vsccw on 2017/7/1.
//  Copyright © 2017年 YOLO. All rights reserved.
//

#import "YLAudioTypeJudge.h"
@import AudioToolbox;

@implementation YLAudioTypeJudge

+ (instancetype)sharedInstance {
    static YLAudioTypeJudge *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (UInt32)audioTypeWithPath:(NSString *)filePath {
    CFStringRef pathToFile = (__bridge CFStringRef)filePath;
    CFURLRef inputFileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, pathToFile, kCFURLPOSIXPathStyle, false);
    ExtAudioFileRef inputFile;
    ExtAudioFileOpenURL(inputFileURL,  &inputFile);
    
    AudioStreamBasicDescription fileDescription;
    UInt32 propertySize = sizeof(fileDescription);
    
    ExtAudioFileGetProperty(inputFile,
                            kExtAudioFileProperty_FileDataFormat,
                            &propertySize,
                            &fileDescription);
    
    return fileDescription.mFormatID;
}

@end


//public var kAudioFormatLinearPCM: AudioFormatID { get }
//public var kAudioFormatAC3: AudioFormatID { get }
//public var kAudioFormat60958AC3: AudioFormatID { get }
//public var kAudioFormatAppleIMA4: AudioFormatID { get }
//public var kAudioFormatMPEG4AAC: AudioFormatID { get }
//public var kAudioFormatMPEG4CELP: AudioFormatID { get }
//public var kAudioFormatMPEG4HVXC: AudioFormatID { get }
//public var kAudioFormatMPEG4TwinVQ: AudioFormatID { get }
//public var kAudioFormatMACE3: AudioFormatID { get }
//public var kAudioFormatMACE6: AudioFormatID { get }
//public var kAudioFormatULaw: AudioFormatID { get }
//public var kAudioFormatALaw: AudioFormatID { get }
//public var kAudioFormatQDesign: AudioFormatID { get }
//public var kAudioFormatQDesign2: AudioFormatID { get }
//public var kAudioFormatQUALCOMM: AudioFormatID { get }
//public var kAudioFormatMPEGLayer1: AudioFormatID { get }
//public var kAudioFormatMPEGLayer2: AudioFormatID { get }
//public var kAudioFormatMPEGLayer3: AudioFormatID { get }
//public var kAudioFormatTimeCode: AudioFormatID { get }
//public var kAudioFormatMIDIStream: AudioFormatID { get }
//public var kAudioFormatParameterValueStream: AudioFormatID { get }
//public var kAudioFormatAppleLossless: AudioFormatID { get }
//public var kAudioFormatMPEG4AAC_HE: AudioFormatID { get }
//public var kAudioFormatMPEG4AAC_LD: AudioFormatID { get }
//public var kAudioFormatMPEG4AAC_ELD: AudioFormatID { get }
//public var kAudioFormatMPEG4AAC_ELD_SBR: AudioFormatID { get }
//public var kAudioFormatMPEG4AAC_ELD_V2: AudioFormatID { get }
//public var kAudioFormatMPEG4AAC_HE_V2: AudioFormatID { get }
//public var kAudioFormatMPEG4AAC_Spatial: AudioFormatID { get }
//public var kAudioFormatAMR: AudioFormatID { get }
//public var kAudioFormatAMR_WB: AudioFormatID { get }
//public var kAudioFormatAudible: AudioFormatID { get }
//public var kAudioFormatiLBC: AudioFormatID { get }
//public var kAudioFormatDVIIntelIMA: AudioFormatID { get }
//public var kAudioFormatMicrosoftGSM: AudioFormatID { get }
//public var kAudioFormatAES3: AudioFormatID { get }
//public var kAudioFormatEnhancedAC3: AudioFormatID { get }
