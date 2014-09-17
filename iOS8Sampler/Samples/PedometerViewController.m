//
//  PedometerViewController.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/09/08.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "PedometerViewController.h"
@import CoreMotion;
#import "SVProgressHUD.h"


@interface PedometerViewController ()
@property (nonatomic, strong) CMPedometer *pedometer;
@property (nonatomic, weak) IBOutlet UILabel *startDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *endDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *stepsLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *ascendedLabel;
@property (nonatomic, weak) IBOutlet UILabel *descendedLabel;
@end


@implementation PedometerViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    
    self.startDateLabel.text = @"";
    self.endDateLabel.text   = @"";
    self.stepsLabel.text     = @"";
    self.distanceLabel.text  = @"";
    self.ascendedLabel.text  = @"";
    self.descendedLabel.text = @"";
    

    if ([CMPedometer isStepCountingAvailable]) {
        
        self.pedometer = [[CMPedometer alloc] init];
    }
    else {
        
        [SVProgressHUD showErrorWithStatus:@"Step counting is not available on this device!"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    [self.pedometer startPedometerUpdatesFromDate:[NSDate date]
                                      withHandler:^(CMPedometerData *pedometerData, NSError *error) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              NSLog(@"data:%@, error:%@", pedometerData, error);
//                                              handler(pedometerData.numberOfSteps);
                                          });
                                      }];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];

    [self.pedometer stopPedometerUpdates];
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


// =============================================================================
#pragma mark - Private

- (NSString *)stringWithObject:(id)obj {
    
    return [NSString stringWithFormat:@"%@", obj];
}

- (NSString *)stringForDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    
    return [formatter stringFromDate:date];
}

- (void)queryDataFrom:(NSDate *)startDate toDate:(NSDate *)endDate
{
    [self.pedometer queryPedometerDataFromDate:startDate
                                        toDate:endDate
                                   withHandler:
     ^(CMPedometerData *pedometerData, NSError *error) {

         NSLog(@"data:%@, error:%@", pedometerData, error);

         dispatch_async(dispatch_get_main_queue(), ^{

             if (error) {
                 
                 [SVProgressHUD showErrorWithStatus:error.localizedDescription];
             }
             else {
                 self.startDateLabel.text = [self stringForDate:pedometerData.startDate];
                 self.endDateLabel.text   = [self stringForDate:pedometerData.endDate];
                 self.stepsLabel.text     = [self stringWithObject:pedometerData.numberOfSteps];
                 self.distanceLabel.text  = [NSString stringWithFormat:@"%.1f[m]", [pedometerData.distance floatValue]];
                 self.ascendedLabel.text  = [self stringWithObject:pedometerData.floorsAscended];
                 self.descendedLabel.text = [self stringWithObject:pedometerData.floorsDescended];
             }
         });
     }];
}


// =============================================================================
#pragma mark - IBAction

- (IBAction)queryBtnTapped:(id)sender {
    
    NSDate *to = [NSDate date];
    NSDate *from = [to dateByAddingTimeInterval:-(24. * 3600.)];
    [self queryDataFrom:from toDate:to];
}

@end
