//
//  HealthKitViewController.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/08/18.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "HealthKitViewController.h"
#import "SVProgressHUD.h"
@import HealthKit;
#import "TTMHealthKitHelper.h"
#import "SVProgressHUD.h"


@interface HealthKitViewController ()
@property (nonatomic, strong) HKHealthStore *healthStore;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end


@implementation HealthKitViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.items = [TTMHealthKitHelper quantityTypes];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if ([HKHealthStore isHealthDataAvailable]) {
        
        [self requestAuthorization];
    }
    else {
        
        [SVProgressHUD showErrorWithStatus:@"HealthKit is not available on this iOS device!!"];
    }
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

- (void)requestAuthorization {

    NSSet *dataTypes = [NSSet setWithArray:self.items];
    
    self.healthStore = [[HKHealthStore alloc] init];    
    [self.healthStore requestAuthorizationToShareTypes:nil
                                             readTypes:dataTypes
                                            completion:
     ^(BOOL success, NSError *error) {
         
         NSString *msg;
         
         if (!success) {
             msg = [NSString stringWithFormat:
                    @"You didn't allow HealthKit to access these read/write data types. Error:%@",
                    error.localizedDescription];
             [SVProgressHUD showErrorWithStatus:msg];
             return;
         }
     }];
}

- (void)fetchQuantity:(HKQuantityType *)type
    completionHandler:(void (^)(HKStatistics *result, NSError *error))completionHandler
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate
                                                               endDate:endDate
                                                               options:HKQueryOptionStrictStartDate];
    
    HKStatisticsOptions options = type.aggregationStyle == HKQuantityAggregationStyleCumulative ? HKStatisticsOptionCumulativeSum : HKStatisticsOptionDiscreteAverage;
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:type
                                                       quantitySamplePredicate:predicate
                                                                       options:options
                                                             completionHandler:
                                ^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
                                    if (completionHandler) {
                                        
                                        if (error) {
                                            completionHandler(nil, error);
                                        }
                                        else {
                                            completionHandler(result, error);
                                        }
                                    }
                                }];
    
    [self.healthStore executeQuery:query];
}


// =============================================================================
#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * const kCellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:kCellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:12.0];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    HKQuantityType *type = self.items[indexPath.row];
    
    cell.textLabel.text = type.identifier;
    
    return cell;
}


// =============================================================================
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    HKQuantityType *type = self.items[indexPath.row];

    [self fetchQuantity:type
      completionHandler:^(HKStatistics *result, NSError *error) {

          dispatch_async(dispatch_get_main_queue(), ^{
              
              NSString *msg;
              
              if (error) {
                  
                  NSLog(@"error:%@", error);
                  msg = [NSString stringWithFormat:@"Failed to fetch! error:%@", error.localizedDescription];
                  [SVProgressHUD showErrorWithStatus:msg];
              }
              else if ([result.sources count] == 0) {
                  
                  [SVProgressHUD showErrorWithStatus:@"NO DATA!"];
              }
              // succeeded to retrieve the health data
              else {
                  
                  NSLog(@"result:%@", result);
                  
                  HKQuantity *resultQuantity = type.aggregationStyle == HKQuantityAggregationStyleCumulative ? result.sumQuantity : result.averageQuantity;
                  HKUnit *unit = [TTMHealthKitHelper defaultUnitForQuantityType:type];
                  double value = [resultQuantity doubleValueForUnit:unit];
                  
                  msg = [NSString stringWithFormat:@"%f %@", value, unit.unitString];
                  
                  [SVProgressHUD showSuccessWithStatus:msg];
              }
          });
      }];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
