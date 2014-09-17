//
//  TTMHealthKitHelper.h
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/09/08.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

@import HealthKit;


@interface TTMHealthKitHelper : NSObject

+ (NSArray *)quantityTypeIdentifiers;
+ (NSArray *)quantityTypes;
+ (HKUnit *)defaultUnitForQuantityType:(HKQuantityType *)type;

@end
