//
//  ViewController.m
//  VideoAddMusic
//
//  Created by Gejiaxin on 2017/8/2.
//  Copyright © 2017年 Filelife. All rights reserved.
//

#import "ViewController.h"
#import "FLVideoBGM.h"
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
            _lab.text = @"Saving.";
            [FLAssetsManager saveVideoWithUrl:[NSURL URLWithString:self.outputFilePath] CompletionHandler:^(NSString *response, BOOL success) {
                if(success) {
                    _lab.text = @"Success";
                } else {
                    _lab.text = @"Failure";
                }
            }];
        } else {
            // Something wrong.
            NSLog(@"%@",errorInfo);
            _lab.text = errorInfo;
        }
    }];

}




@end
