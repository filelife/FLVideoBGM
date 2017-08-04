//
//  FLVideoBGMManager.m
//  VideoAddMusic
//
//  Created by Gejiaxin on 2017/8/3.
//  Copyright © 2017年 Filelife. All rights reserved.
//

#import "FLVideoBGMManager.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
@implementation FLVideoBGMManager
+ (void)processVideo:(NSURL *)videoUrl
         InsertMusic:(NSURL *)musicUrl
    CompletionHandle:( void(^)(NSString * resultOutputFilePath,NSString * errorInfo))completionHandler{
    // start time.
    CMTime nextClistartTime = kCMTimeZero;
    
    AVMutableComposition * comosition = [AVMutableComposition composition];
    
    AVURLAsset * videoAsset = [[AVURLAsset alloc] initWithURL:videoUrl
                                                      options:nil];
    if(!videoAsset.isPlayable) {
        completionHandler(nil,@"Video asset could't play.Please check your videoUrl.");
    }
    // video time range
    CMTimeRange videoTimeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    
    AVMutableCompositionTrack * videoTrack = [comosition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    // track of video.
    AVAssetTrack * videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    // add asset into video track 
    [videoTrack insertTimeRange:videoTimeRange ofTrack:videoAssetTrack atTime:nextClistartTime error:nil];


    AVURLAsset * audioAsset = [[AVURLAsset alloc] initWithURL:musicUrl
                                                      options:nil];
    if(!audioAsset.isPlayable) {
        completionHandler(nil,@"Audio asset could't play.Please check your audioUrl.");
    }
    // audio time range
    CMTimeRange audioTimeRange = videoTimeRange;
    // audio track
    AVMutableCompositionTrack * audioTrack = [comosition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //
    AVAssetTrack * audioAssetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    // add asset into music track
    [audioTrack insertTimeRange:audioTimeRange ofTrack:audioAssetTrack atTime:nextClistartTime error:nil];
    
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    
    // video layer instruction
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ = UIImageOrientationRight;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ =  UIImageOrientationLeft;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
        videoAssetOrientation_ =  UIImageOrientationUp;
    }
    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
        videoAssetOrientation_ = UIImageOrientationDown;
    }
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:videoAsset.duration];
    
    
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    
    NSArray  * dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * docsDir = [dirPaths objectAtIndex:0];
    __block NSString *outputFilePath = [docsDir stringByAppendingPathComponent:@"FLOutputFile.mov"];
    // Check to see if it exists.
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:outputFilePath]) {
        NSError *error = nil;
        [fileManager removeItemAtPath:outputFilePath error:&error];
        if (error) {
            NSLog(@"Delete error:%@", error);
            completionHandler(nil,@"File write error.");
        } else {
            NSLog(@"Delete old one and will save new one here ：%@",outputFilePath);
        }
    } else {
        NSLog(@"The final file wil save here:%@",outputFilePath);
    }
    
    AVAssetExportSession * assetExport = [[AVAssetExportSession alloc] initWithAsset:comosition presetName:AVAssetExportPresetMediumQuality];
    assetExport.outputURL = [NSURL fileURLWithPath:outputFilePath];
    assetExport.outputFileType = AVFileTypeMPEG4;
    assetExport.shouldOptimizeForNetworkUse = YES;
    assetExport.videoComposition = mainCompositionInst;
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            switch (assetExport.status) {
                case AVAssetExportSessionStatusWaiting:
                    break;
                case AVAssetExportSessionStatusUnknown:
                    break;
                case AVAssetExportSessionStatusCancelled:
                    break;
                case AVAssetExportSessionStatusFailed: // failure.
                    completionHandler(nil,assetExport.error.description);
                    break;
                case AVAssetExportSessionStatusExporting:
                    NSLog(@"AVAssetExportSessionExporting");
                    break;
                case AVAssetExportSessionStatusCompleted: // success
                    NSLog(@"exportSessionCompleted");
                    completionHandler(outputFilePath,@"Export video Success");
                    break;
            }
            
        });
    }];

}
@end
