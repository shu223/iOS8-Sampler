//
//  AnamorphicStretch.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/08/18.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "AnamorphicStretch.h"
@import UIKit;


@implementation AnamorphicStretch

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

//- (CIImage *) outputImage {
//    CGFloat inputWidth = self.inputImage.extent.size.width;
//    
//    CIImage *result = [[self myKernel] applyWithExtent:self.inputImage.extent
//                                           roiCallback:^CGRect(int index, CGRect rect) {
//                                               
//                                               // ?
//                                               CGFloat newOrigin = self.inputImage.extent.size.width - ( rect.origin.x + rect.size.width );
//                                               return CGRectMake(newOrigin, rect.origin.y, rect.size.width, rect.size.height);
//                                               
//                                           } inputImage:self.inputImage
//                                             arguments:@[@(inputWidth)]];
//    return result;
//}

double destToSource(double x, double center, double k)
{
    x -= center;
    x = x / (1.0 + fabs(x / k));
    x += center;
    return x;
}

CGRect regionOf (CGRect r, float center, float k)
{
    double leftP = destToSource (r.origin.x, center, k);
    double rightP = destToSource (r.origin.x + r.size.width, center, k);
    return CGRectMake (leftP, r.origin.y, rightP-leftP, r.size.height);
}

double sourceToDest (double x, double center, double k)
{
    x -= center;
    x = x / (1.0 - fabs(x / k));
    x += center;
    return x;
}

CGRect dodForInputRect (CGRect r, double center, double k)
{
    double leftP = sourceToDest (r.origin.x, center, k);
    double rightP = sourceToDest (r.origin.x + r.size.width, center, k);
    return CGRectMake (leftP, r.origin.y, rightP-leftP, r.size.height);
}

- (CIImage *)outputImage {

    double inputWidth = self.inputImage.extent.size.width;
    
    double k = inputWidth / (1.0 - 1.0 / [self.inputScale floatValue]);
    double center = self.inputImage.extent.origin.x + inputWidth / 2.0;
    
    CGRect dod = dodForInputRect(self.inputImage.extent, center, k);
    
    CIImage *result = [[self myKernel] applyWithExtent:dod
                                           roiCallback:^CGRect(int index, CGRect rect) {

                                               return regionOf(rect, center, k);
                                               
                                           } inputImage:self.inputImage
                                             arguments:@[@(center), @(k)]];

    return result;
}

@end
