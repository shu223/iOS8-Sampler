//
//  SourceOver.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/08/18.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "SourceOver.h"

@implementation SourceOver

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
    
    CGRect dod = CGRectUnion ( self.inputImage.extent, self.inputBackgroundImage.extent );
    
    return [[self myKernel] applyWithExtent : dod
                                  arguments : @[self.inputImage, self.inputBackgroundImage]];
}

@end
