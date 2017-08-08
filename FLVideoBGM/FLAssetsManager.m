//
//  FLAssetsManager.m
//  VideoAddMusic
//
//  Created by Gejiaxin on 2017/8/3.
//  Copyright © 2017年 Filelife. All rights reserved.
//

#import "FLAssetsManager.h"
#import <Photos/Photos.h>
@implementation FLAssetsManager

+ (void)saveVideoWithUrl:(NSURL *)path CompletionHandler:( void(^)(NSString * response,BOOL success))completionHandler {
        __block NSString *localIdentifier = nil;
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:path];
        localIdentifier = request.placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError *error) {
        if(completionHandler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    completionHandler(@"Success",YES);
                } else {
                    completionHandler(@"Save video failure",NO);
                    
                }
                
            });
        }
    }];
    
    
}



@end
