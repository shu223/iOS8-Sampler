//
//  HistogramViewController.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/08/18.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "HistogramViewController.h"
#import "TTMHistogramHelper.h"
#import "UIView+TTMGeometry.h"
#import "SVProgressHUD.h"


@interface HistogramViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIImageView *histoView;
@end


@implementation HistogramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.histoView.alpha = 0.9;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewDidLayoutSubviews {
    
    self.histoView.frame = CGRectMake(0, 0, self.histoView.image.size.width, self.histoView.image.size.height);
}


// =============================================================================
#pragma mark - Private

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

- (IBAction)btnTapped:(id)sender {
    
    [SVProgressHUD show];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{

        // compute
        CIImage *dataImage = [TTMHistogramHelper computeHistogramForImage:self.imageView.image count:64];
        
        // generate
        UIImage *outImage = [TTMHistogramHelper generateHistogramImageFromDataImage:dataImage];

        // resize
        UIImage *resized = [self resizeImage:outImage
                                 withQuality:kCGInterpolationNone
                                        rate:2.5];

        dispatch_async(dispatch_get_main_queue(), ^{

            // draw
            self.histoView.image = resized;
            
            [SVProgressHUD dismiss];
        });
    });
}

@end
