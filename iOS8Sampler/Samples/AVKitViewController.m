//
//  AVKitViewController.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/09/08.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "AVKitViewController.h"
@import AVKit;
@import AVFoundation;
#import "SVProgressHUD.h"


NSString * const kPlayerItemUrl = @"http://devstreaming.apple.com/videos/wwdc/2014/503xx50xm4n63qe/503/503_sd_mastering_modern_media_playback.mov";


@interface AVKitViewController ()

@end


@implementation AVKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)playBtnTapped:(id)sender {

    [SVProgressHUD show];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{

        NSURL *url = [NSURL URLWithString:kPlayerItemUrl];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
        AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
        
        AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
        playerViewController.player = player;

        dispatch_async(dispatch_get_main_queue(), ^{

            [SVProgressHUD dismiss];
            [self presentViewController:playerViewController
                               animated:YES
                             completion:^{
                             }];
        });
    });    
}

@end
