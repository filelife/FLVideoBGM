//
//  ViewController.m
//  VideoAddMusic
//
//  Created by Gejiaxin on 2017/8/2.
//  Copyright © 2017年 Filelife. All rights reserved.
//

#import "ViewController.h"
#import "FLAssetsManager.h"
#import "FLVideoBGMManager.h"
@interface ViewController ()
@property (nonatomic, copy) NSString * outputFilePath;
@property (nonatomic, strong) IBOutlet UILabel * lab;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self VideoAddMusic];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)VideoAddMusic {
    NSURL * videoUrl=  [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ARShoot" ofType:@"mov"]];
    NSURL * musicUrl=  [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"AreYouOK" ofType:@"mp3"]];
    
    [FLVideoBGMManager processVideo:videoUrl InsertMusic:musicUrl CompletionHandle:^(NSString *resultOutputFilePath, NSString *errorInfo) {
        if(resultOutputFilePath) {
            // Saving success.
            self.outputFilePath = resultOutputFilePath;
            _lab.text = @"Check album.";
            [FLAssetsManager checkAlbumBeforeSaveWithCompletionHandler:^(BOOL createNewCollection) {
                [FLAssetsManager saveVideoWithUrl:[NSURL URLWithString:self.outputFilePath]];
                //You could delete origin video at here.
                _lab.text = @"Success";
            }];
            
        } else {
            // Something wrong.
            NSLog(@"%@",errorInfo);
            _lab.text = errorInfo;
        }
    }];

}




@end
