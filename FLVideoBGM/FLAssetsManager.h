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
 * @ Func:Course PHPhotolibrary require to choose a album before save asset.
 * @ Param
 *   completionHandler
 */
+ (void)checkAlbumBeforeSaveWithCompletionHandler:(void(^)(BOOL createNewCollection))completionHandler;

/*
 * @ Func:Save video
 * @ Param
 *   path : video path
 */
+ (void)saveVideoWithUrl:(NSURL *)path;
@end
