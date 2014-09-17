//
//  HistogramHelper.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/08/18.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "TTMHistogramHelper.h"

@implementation TTMHistogramHelper

/* Attributes for CIAreaHistgram
 {
 CIAttributeFilterCategories =     (
 CICategoryReduction,
 CICategoryVideo,
 CICategoryStillImage,
 CICategoryBuiltIn
 );
 CIAttributeFilterDisplayName = "Area Histogram";
 CIAttributeFilterName = CIAreaHistogram;
 inputCount =     {
 CIAttributeClass = NSNumber;
 CIAttributeDefault = 64;
 CIAttributeMax = 256;
 CIAttributeMin = 1;
 CIAttributeSliderMax = 256;
 CIAttributeSliderMin = 10;
 CIAttributeType = CIAttributeTypeScalar;
 };
 inputExtent =     {
 CIAttributeClass = CIVector;
 CIAttributeDefault = "[0 0 300 300]";
 CIAttributeType = CIAttributeTypeRectangle;
 };
 inputImage =     {
 CIAttributeClass = CIImage;
 CIAttributeType = CIAttributeTypeImage;
 };
 inputScale =     {
 CIAttributeClass = NSNumber;
 CIAttributeDefault = 1;
 CIAttributeMin = 0;
 CIAttributeSliderMax = 1;
 CIAttributeSliderMin = 0;
 CIAttributeType = CIAttributeTypeScalar;
 };
 }
 */
+ (CIImage *)computeHistogramForImage:(UIImage *)inputImage count:(NSUInteger)count {

    count = count <= 256 ? count : 256;
    count = count >= 1 ? count : 1;
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:inputImage];
    
    NSDictionary *params = @{kCIInputImageKey: ciImage,
                             kCIInputExtentKey: [CIVector vectorWithCGRect:[ciImage extent]],
                             @"inputCount": @(count),
                             };
    
    CIFilter *filter = [CIFilter filterWithName:@"CIAreaHistogram"
                            withInputParameters:params];
    
    return [filter outputImage];
}

/* Attributes for CIHistogramDisplayFilter
 {
 CIAttributeFilterCategories =     (
 CICategoryReduction,
 CICategoryVideo,
 CICategoryStillImage,
 CICategoryBuiltIn
 );
 CIAttributeFilterDisplayName = "Histogram Display";
 CIAttributeFilterName = CIHistogramDisplayFilter;
 inputHeight =     {
 CIAttributeClass = NSNumber;
 CIAttributeDefault = 0;
 CIAttributeMax = 200;
 CIAttributeMin = 1;
 CIAttributeSliderMax = 100;
 CIAttributeSliderMin = 1;
 CIAttributeType = CIAttributeTypeScalar;
 };
 inputHighLimit =     {
 CIAttributeClass = NSNumber;
 CIAttributeDefault = 1;
 CIAttributeMax = 1;
 CIAttributeMin = 0;
 CIAttributeSliderMax = 1;
 CIAttributeSliderMin = 0;
 CIAttributeType = CIAttributeTypeScalar;
 };
 inputImage =     {
 CIAttributeClass = CIImage;
 CIAttributeType = CIAttributeTypeImage;
 };
 inputLowLimit =     {
 CIAttributeClass = NSNumber;
 CIAttributeDefault = 0;
 CIAttributeMax = 1;
 CIAttributeMin = 0;
 CIAttributeSliderMax = 1;
 CIAttributeSliderMin = 0;
 CIAttributeType = CIAttributeTypeScalar;
 };
 }
 */
+ (UIImage *)generateHistogramImageFromDataImage:(CIImage *)dataImage {
    
    CIContext *context = [CIContext contextWithOptions:nil];
    NSDictionary *params = @{
                             kCIInputImageKey: dataImage,
                             };
    CIFilter *filter = [CIFilter filterWithName:@"CIHistogramDisplayFilter"
                            withInputParameters:params];
    
    CIImage *outputImage = [filter outputImage];
    CGRect outExtent = [outputImage extent];
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:outExtent];
    
    
    UIImage *outImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return outImage;
}

@end
