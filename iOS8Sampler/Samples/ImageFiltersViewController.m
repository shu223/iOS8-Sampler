//
//  ImageFiltersViewController.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/08/18.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "ImageFiltersViewController.h"
#import "SVProgressHUD.h"


@interface ImageFiltersViewController ()
<UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *orgImage;
@property (nonatomic, strong) NSArray *items;
@end


@implementation ImageFiltersViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.orgImage = self.imageView.image;
    self.imageView.image = self.orgImage;
    
    self.items = @[@"Original",
                   @"CIGlassDistortion",
                   @"CIDivideBlendMode",
                   @"CILinearBurnBlendMode",
                   @"CILinearDodgeBlendMode",
                   @"CIPinLightBlendMode",
                   @"CISubtractBlendMode",
                   ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    
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
#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.items.count;
}


// =============================================================================
#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.items[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (row == 0) {
        self.imageView.image = self.orgImage;
        return;
    }
    
    [SVProgressHUD show];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        // Create CIFilter object
        CIImage *ciImage = [[CIImage alloc] initWithImage:self.orgImage];
        
        NSDictionary *params = @{
                                 kCIInputImageKey: ciImage,
                                 };
        
        CIFilter *filter = [CIFilter filterWithName:self.items[row] withInputParameters:params];
        [filter setDefaults];
        
        // param for distortion
        if ([filter respondsToSelector:NSSelectorFromString(@"inputTexture")]) {
            CIImage *ciTextureImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"grassdistortion"]];
            [filter setValue:ciTextureImage forKey:@"inputTexture"];
        }
        
        // params for blend mode
        if ([filter respondsToSelector:NSSelectorFromString(@"inputBackgroundImage")]) {
            CIImage *ciOverlayImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"m5full3"]];
            [filter setValue:ciImage forKey:@"inputBackgroundImage"];
            [filter setValue:ciOverlayImage forKey:kCIInputImageKey];
        }
        
        // Apply filter
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *outputImage = [filter outputImage];
        CGImageRef cgImage = [context createCGImage:outputImage
                                           fromRect:[outputImage extent]];
        UIImage *image = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);

        dispatch_async(dispatch_get_main_queue(), ^{
            
            // draw
            self.imageView.image = image;
            [SVProgressHUD dismiss];
        });
    });
}

@end
