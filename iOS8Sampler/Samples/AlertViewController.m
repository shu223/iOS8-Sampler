//
//  AlertViewController.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/08/19.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "AlertViewController.h"


NSString * const fontName = @"AvenirNext-Medium";


@interface AlertViewController ()
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedCtl;
@end


@implementation AlertViewController

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


// =============================================================================
#pragma mark - IBAction

- (IBAction)alertBtnTapped:(id)sender {
    
    UIAlertControllerStyle style;
    switch (self.segmentedCtl.selectedSegmentIndex) {
        case 0:
        default:
            style = UIAlertControllerStyleAlert;
            break;
        case 1:
            style = UIAlertControllerStyleActionSheet;
            break;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"TITLE"
                                                                   message:@"MESSAGE"
                                                            preferredStyle:style];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                                                         
                                                         NSLog(@"OK!");
                                                     }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"CANCEL"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                             
                                                             NSLog(@"CANCEL!");
                                                         }];
    UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:@"DESTRUCT"
                                                                style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction *action) {
                                                                  NSLog(@"DESTRUCT");
                                                              }];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [alert addAction:destructiveAction];
    
    // add test field
    if (style == UIAlertControllerStyleAlert) {
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.font = [UIFont fontWithName:fontName size:textField.font.pointSize];
        }];
    }

    [self presentViewController:alert
                       animated:YES
                     completion:^{
                     }];
}

@end
