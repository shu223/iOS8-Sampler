//
//  CodeGeneratorViewController.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/08/18.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "CodeGeneratorViewController.h"


#define kText @"https://twitter.com/shu223"


@interface CodeGeneratorViewController ()
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedCtl;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@end


@implementation CodeGeneratorViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    [self generateCode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

- (void)generateCode {

    NSString *filtername = nil;
    switch (self.segmentedCtl.selectedSegmentIndex) {
        case 0:
        default:
            filtername = @"CIAztecCodeGenerator";
            break;
        case 1:
            filtername = @"CICode128BarcodeGenerator";
            break;
    }
    
    CIFilter *filter = [CIFilter filterWithName:filtername];
    [filter setDefaults];
    
    NSData *data = [kText dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    UIImage *image = [UIImage imageWithCGImage:cgImage
                                         scale:1.
                                   orientation:UIImageOrientationUp];
    
    // Resize without interpolating
    CGFloat scaleRate = self.imageView.frame.size.width / image.size.width;
    UIImage *resized = [self resizeImage:image
                             withQuality:kCGInterpolationNone
                                    rate:scaleRate];
    
    self.imageView.image = resized;
    
    CGImageRelease(cgImage);
}

- (UIImage *)resizeImage:(UIImage *)image
             withQuality:(CGInterpolationQuality)quality
                    rate:(CGFloat)rate
{
    UIImage *resized = nil;
    CGFloat width = image.size.width * rate;
    CGFloat height = image.size.height * rate;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resized;
}


// =============================================================================
#pragma mark - IBAction

- (IBAction)segmentChanged:(id)sender {
    
    [self generateCode];
}

@end
