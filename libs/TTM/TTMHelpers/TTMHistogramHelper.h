//
//  HistogramHelper.h
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/08/18.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTMHistogramHelper : NSObject

+ (CIImage *)computeHistogramForImage:(UIImage *)inputImage count:(NSUInteger)count;
+ (UIImage *)generateHistogramImageFromDataImage:(CIImage *)dataImage;

@end
