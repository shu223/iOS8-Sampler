//
//  Vignette.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/08/18.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "Vignette.h"

@implementation Vignette

- (CIColorKernel *)myKernel {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:NSStringFromClass([self class])
                                                     ofType:@"cikernel"];
    NSString *kernelStr = [NSString stringWithContentsOfFile:path
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    static CIColorKernel *kernel = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        kernel = [CIColorKernel kernelWithString:kernelStr];
    });
    return kernel;
}

- (CIImage *)outputImage {
    
    CGRect dod = self.inputImage.extent;
    double radius = 0.5 * hypot ( dod.size.width, dod.size.height );
    
    CIVector *centerOffset = [CIVector vectorWithX : dod.size.width * 0.5 + dod.origin.x
                                                 Y : dod.size.height * 0.5 + dod.origin.y];

    return [[self myKernel] applyWithExtent : dod
                                  arguments : @[self.inputImage, centerOffset, @(radius)]];
}

@end
