//
//  TTMAudioUnitEffectHelper.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/09/08.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "TTMAudioUnitEffectHelper.h"


NSString * const kAVAudioUnitDistortionPresetPrefix = @"AVAudioUnitDistortionPreset";


@implementation TTMAudioUnitEffectHelper

+ (NSArray *)factoryPresets {
    
    return @[
             @{@"AVAudioUnitDistortionPresetDrumsBitBrush"      : @0},
             @{@"AVAudioUnitDistortionPresetDrumsBufferBeats"   : @1},
             @{@"AVAudioUnitDistortionPresetDrumsLoFi"          : @2},
             @{@"AVAudioUnitDistortionPresetMultiBrokenSpeaker" : @3},
             @{@"AVAudioUnitDistortionPresetMultiCellphoneConcert": @4},
             @{@"AVAudioUnitDistortionPresetMultiDecimated1"    : @5},
             @{@"AVAudioUnitDistortionPresetMultiDecimated2"    : @6},
             @{@"AVAudioUnitDistortionPresetMultiDecimated3"    : @7},
             @{@"AVAudioUnitDistortionPresetMultiDecimated4"    : @8},
             @{@"AVAudioUnitDistortionPresetMultiDistortedFunk" : @9},
             @{@"AVAudioUnitDistortionPresetMultiDistortedCubed": @10},
             @{@"AVAudioUnitDistortionPresetMultiDistortedSquared": @11},
             @{@"AVAudioUnitDistortionPresetMultiEcho1"         : @12},
             @{@"AVAudioUnitDistortionPresetMultiEcho2"         : @13},
             @{@"AVAudioUnitDistortionPresetMultiEchoTight1"    : @14},
             @{@"AVAudioUnitDistortionPresetMultiEchoTight2"    : @15},
             @{@"AVAudioUnitDistortionPresetMultiEverythingIsBroken": @16},
             @{@"AVAudioUnitDistortionPresetSpeechAlienChatter" : @17},
             @{@"AVAudioUnitDistortionPresetSpeechCosmicInterference": @18},
             @{@"AVAudioUnitDistortionPresetSpeechGoldenPi"     : @19},
             @{@"AVAudioUnitDistortionPresetSpeechRadioTower"   : @20},
             @{@"AVAudioUnitDistortionPresetSpeechWaves"        : @21}
             ];
}

+ (NSDictionary *)factoryPresetDictionary {
    
    NSMutableDictionary *presetDic = @{}.mutableCopy;
    for (NSDictionary *aDic in [self factoryPresets]) {
        [presetDic addEntriesFromDictionary:aDic];
    }
    
    return presetDic;
}

+ (NSArray *)factoryPresetNames {
    
    NSMutableArray *names = @[].mutableCopy;
    
    for (NSDictionary *dic in [self factoryPresets]) {
        for (id key in [dic keyEnumerator]) {
            [names addObject:key];
        }
    }
    
    return names;
}

+ (NSArray *)factoryPresetShortNames {
    
    NSMutableArray *shortNames = @[].mutableCopy;
    NSArray *names = [self factoryPresetNames];
    
    for (NSString *aName in names) {
        NSString *shortName = [aName stringByReplacingOccurrencesOfString:kAVAudioUnitDistortionPresetPrefix withString:@""];
        [shortNames addObject:shortName];
    }
    
    return shortNames;
}

+ (NSInteger)valueForFactoryPresetName:(NSString *)name {
    
    NSDictionary *dic = [self factoryPresetDictionary];
    NSNumber *value = dic[name];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value integerValue];
    }
    
    // not found
    return -1;
}

+ (NSInteger)valueForFactoryPresetShortName:(NSString *)shortName {
    
    NSString *name = [kAVAudioUnitDistortionPresetPrefix stringByAppendingString:shortName];
    
    return [self valueForFactoryPresetName:name];
}

@end
