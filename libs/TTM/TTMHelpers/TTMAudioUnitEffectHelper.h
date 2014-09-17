//
//  TTMAudioUnitEffectHelper.h
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/09/08.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>


@interface TTMAudioUnitEffectHelper : NSObject

+ (NSArray *)factoryPresetNames;
+ (NSArray *)factoryPresetShortNames;

+ (NSInteger)valueForFactoryPresetName:(NSString *)name;
+ (NSInteger)valueForFactoryPresetShortName:(NSString *)shortName;

@end
