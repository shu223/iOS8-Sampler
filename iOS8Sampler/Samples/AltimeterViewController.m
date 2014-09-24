//
//  AltimeterViewController.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 9/24/14.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//
//  Thanks to:
//  http://nshipster.com/ios8/
//  http://dev.classmethod.jp/references/ios8-cmaltimeter/


#import "AltimeterViewController.h"
@import CoreMotion;
#import "SVProgressHUD.h"


@interface AltimeterViewController ()
@property (nonatomic, strong) CMAltimeter *altimeter;
@property (nonatomic, weak) IBOutlet UILabel *altitudeLabel;
@property (nonatomic, weak) IBOutlet UILabel *pressureLabel;
@property (nonatomic, weak) IBOutlet UILabel *timestampLabel;
@end


@implementation AltimeterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([CMAltimeter isRelativeAltitudeAvailable]) {
        
        self.altimeter = [[CMAltimeter alloc] init];
    }
    else {
        
        [SVProgressHUD showErrorWithStatus:@"Relative altitude is not available on this device!"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.altimeter startRelativeAltitudeUpdatesToQueue:[NSOperationQueue mainQueue]
                                            withHandler:
     ^(CMAltitudeData *altitudeData, NSError *error) {
         
         NSLog(@"altitudeData:%@, error:%@", altitudeData, error);
         
         if (error) {
         }
         else {
             
             self.altitudeLabel.text = [NSString stringWithFormat:@"%@", altitudeData.relativeAltitude];
             self.pressureLabel.text = [NSString stringWithFormat:@"%@", altitudeData.pressure];
             self.timestampLabel.text = [NSString stringWithFormat:@"%f", altitudeData.timestamp];
         }
     }];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.altimeter stopRelativeAltitudeUpdates];
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


@end
