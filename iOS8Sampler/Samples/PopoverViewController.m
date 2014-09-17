//
//  PopoverViewController.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/09/14.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "PopoverViewController.h"
#import "PopoverDetailViewController.h"


@interface PopoverViewController ()
@end


@implementation PopoverViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    for (UIView *aSubview in self.view.subviews) {
        if (![aSubview isKindOfClass:[UIButton class]]) {
            continue;
        }
        UIImage *image = [self imageForTag:aSubview.tag];
        [(UIButton *)aSubview setImage:image forState:UIControlStateNormal];
    }
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


// =============================================================================
#pragma mark - Private

- (UIImage *)imageForTag:(NSInteger)tag {

    NSString *filename = [NSString stringWithFormat:@"m%ld", (long)tag];
    UIImage *image = [UIImage imageNamed:filename];
    return image;
}


// =============================================================================
#pragma mark - Action

- (IBAction)showBtnTapped:(UIButton *)sender {

    PopoverDetailViewController *detailCtr = [[PopoverDetailViewController alloc] init];
    detailCtr.modalPresentationStyle = UIModalPresentationPopover;
    detailCtr.image = [self imageForTag:sender.tag];

    UIPopoverPresentationController *popoverCtr = detailCtr.popoverPresentationController;
    popoverCtr.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    [self presentViewController:detailCtr
                       animated:YES
                     completion:^{
                     }];
}

@end
