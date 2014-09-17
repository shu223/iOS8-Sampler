//
//  MirrorX.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/08/18.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "MirrorX.h"

@implementation MirrorX

- (CIWarpKernel *)myKernel {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:NSStringFromClass([self class])
                                                     ofType:@"cikernel"];
    NSString *kernelStr = [NSString stringWithContentsOfFile:path
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    static CIWarpKernel *kernel = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        kernel = [CIWarpKernel kernelWithString:kernelStr];
    });
    return kernel;
}

- (CIImage *) outputImage {

    CGFloat inputWidth = self.inputImage.extent.size.width;
    
    CIImage *result = [[self myKernel] applyWithExtent:self.inputImage.extent
                                           roiCallback:^CGRect(int index, CGRect rect) {
                                               
                                               // ?
                                               CGFloat newOrigin = self.inputImage.extent.size.width - ( rect.origin.x + rect.size.width );
                                               return CGRectMake(newOrigin, rect.origin.y, rect.size.width, rect.size.height);
                                               
                                           } inputImage:self.inputImage
                                             arguments:@[@(inputWidth)]];
    return result;
}

@end
