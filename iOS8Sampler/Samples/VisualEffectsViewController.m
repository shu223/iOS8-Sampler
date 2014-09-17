//
//  VisualEffectsViewController.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/08/18.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "VisualEffectsViewController.h"
#import "UIView+TTMGeometry.h"


NSString * const VibrancyText1 = @"This label is affected with UIVibrancyEffect.";
NSString * const VibrancyText2 = @"This label is NOT affected with UIVibrancyEffect.";


@interface VisualEffectsViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedCtl;
@property (nonatomic, strong) UIVisualEffectView *blurEffectView;
@property (nonatomic, strong) UIVisualEffectView *vibrancyEffectView;
@property (nonatomic, weak) IBOutlet UISwitch *vibrancySwitch;
@end


@implementation VisualEffectsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
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

- (IBAction)segmentChanged:(id)sender {
    
    UIVisualEffect *effect;
    
    if ([self.blurEffectView superview]) {
        [self.blurEffectView removeFromSuperview];
    }
    
    switch (self.segmentedCtl.selectedSegmentIndex) {
        case 0:
        default:
            self.blurEffectView = nil;
            [self.vibrancySwitch setOn:NO];
            [self switchChanged:nil];
            return;
            
        case 1:
            effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            break;
            
        case 2:
            effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            break;
            
        case 3:
            effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            break;
    }
    self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    self.blurEffectView.frame = self.imageView.bounds;
    [self.imageView addSubview:self.blurEffectView];
    
    [self switchChanged:nil];
}

- (UILabel *)labelForText:(NSString *)text {

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 240)];
    [label setText:text];
    [label setNumberOfLines:0];
    [label setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:20.0f]];
    [label sizeToFit];
    return label;
}

- (IBAction)switchChanged:(id)sender {
    
    if (self.vibrancySwitch.isOn) {
        
        // vibrancy effect view
        UIVibrancyEffect *effect = [UIVibrancyEffect effectForBlurEffect:(UIBlurEffect *)self.blurEffectView.effect];
        self.vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        self.vibrancyEffectView.frame = self.blurEffectView.bounds;

        UILabel *vibrancyLabel = [self labelForText:VibrancyText1];
        [vibrancyLabel setCenter:CGPointMake(self.view.center.x, self.view.center.y + 20)];
        [[self.vibrancyEffectView contentView] addSubview:vibrancyLabel];
        
        [[self.blurEffectView contentView] addSubview:self.vibrancyEffectView];

        // label without vibrancy effect
        UILabel *normalLabel = [self labelForText:VibrancyText2];
        [normalLabel setCenter:CGPointMake(self.view.center.x, vibrancyLabel.bottom + 40)];
        [self.blurEffectView addSubview:normalLabel];
    }
    else {
        
        if ([self.vibrancyEffectView superview]) {
            [self.vibrancyEffectView removeFromSuperview];
        }
        self.vibrancyEffectView = nil;
    }
}

@end
