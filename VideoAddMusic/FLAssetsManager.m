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

+ (void)checkAlbumBeforeSaveWithCompletionHandler:( void(^)(BOOL createNewCollection))completionHandler{
    
    __block NSString *appTitle = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
    
    PHAssetCollection *createdCollection = nil;
    
    // Get all collection here.
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                                               subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                                               options:nil];
    
    for (PHAssetCollection *collection in collections) {
        NSLog(@"The album name is:%@",collection.localizedTitle);
        if ([collection.localizedTitle isEqualToString:appTitle]) {
            createdCollection = collection;
            //The name of this photo album is the same as your app.
            break;
        }
    }
    if (!createdCollection) {
        // if you don't have a same one, the system will create an album named after your app.
        NSLog(@"Get new collection.");
        dispatch_async(dispatch_get_main_queue(), ^{
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{

                NSLog(@"Get new collection and prepare to save video.");
                NSString *createdCollectionId = nil;
                createdCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:appTitle].placeholderForCreatedAssetCollection.localIdentifier;
                completionHandler(YES);
            } error:nil];
        });
        
    } else {
        NSLog(@"Get collection.");
        completionHandler(NO);
    }
}

+ (void)saveVideoWithUrl:(NSURL *)path {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        PHFetchResult<PHAssetCollection *> *collectonResuts = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                                                       subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                                                       options:nil];
        [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            PHAssetCollection *assetCollection = obj;
            NSLog(@"Album Title:%@",assetCollection.localizedTitle);
            NSString *appTitle = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
            if([assetCollection.localizedTitle isEqualToString:appTitle]) {
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    
                    PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:path];
                    
                    PHAssetCollectionChangeRequest *collectonRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                    
                    PHObjectPlaceholder *placeHolder = [assetRequest placeholderForCreatedAsset];
                    
                    [collectonRequest addAssets:@[placeHolder]];
                } completionHandler:^(BOOL success, NSError *error) {
                    if (success) {
                        NSLog(@"Save video success");
                    } else {
                        NSLog(@"Save video failure:%@", error.userInfo);
                    }
                }];
            } else {
                NSLog(@"Can't find collection.");
            }
        }];
    });
}

@end
