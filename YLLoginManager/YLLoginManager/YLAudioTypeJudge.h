//
//  YLAudioTypeJudge.h
//  YLLoginManager
//
//  Created by vsccw on 2017/7/1.
//  Copyright © 2017年 YOLO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLAudioTypeJudge : NSObject

+ (instancetype)sharedInstance;

- (UInt32)audioTypeWithPath:(NSString *)filePath;

@end
