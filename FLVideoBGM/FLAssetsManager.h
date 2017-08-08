//
//  FLAssetsManager.h
//  VideoAddMusic
//
//  Created by Gejiaxin on 2017/8/3.
//  Copyright © 2017年 Filelife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLAssetsManager : NSObject
/*
 * @ Func:Save video
 * @ Param
 *   path : video path
 */
+ (void)saveVideoWithUrl:(NSURL *)path CompletionHandler:( void(^)(NSString * response,BOOL success))completionHandler;



@end
