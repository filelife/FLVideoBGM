//
//  FLVideoBGMManager.h
//  VideoAddMusic
//
//  Created by Gejiaxin on 2017/8/3.
//  Copyright © 2017年 Filelife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLVideoBGMManager : NSObject

/*
 * @ Func : Insert the background music into the target video file.
 * @ Param
 *   videoUrl : video file absolute path.
 *   musicUrl : background music file absolute path.
 *   completionHandelr : the callback block of process completion handler.
 *   resultOutputFilePath : final video file saving path.
 *   errorInfo : return error info.
 */
+ (void)processVideo:(NSURL *)videoUrl
         InsertMusic:(NSURL *)musicUrl
    CompletionHandle:( void(^)(NSString * resultOutputFilePath,NSString * errorInfo))completionHandler;

@end
