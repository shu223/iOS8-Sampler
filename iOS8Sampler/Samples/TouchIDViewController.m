//
//  TouchIDViewController.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/08/18.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "TouchIDViewController.h"
#import "SVProgressHUD.h"
@import LocalAuthentication;


@interface TouchIDViewController ()

@end


@implementation TouchIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
#pragma mark - IBAction

- (IBAction)evaluateBtnTapped:(id)sender {
    
    LAContext *context = [[LAContext alloc] init];
    NSError *error;

    // check if the policy can be evaluated
    if (![context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        NSLog(@"error:%@", error);
        NSString *msg = [NSString stringWithFormat:@"Can't evaluate policy! %@", error.localizedDescription];
        [SVProgressHUD showErrorWithStatus:msg];
        return;
    }

    // evaluate
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
            localizedReason:@"{Application reason for authentication}"
                      reply:
     ^(BOOL success, NSError *authenticationError) {
         
         dispatch_async(dispatch_get_main_queue(), ^{
             
             if (success) {
                 [SVProgressHUD showSuccessWithStatus:@"SUCCEEDED!"];
             }
             else {
                 NSLog(@"error:%@", authenticationError);
                 [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"FAILED! %@", authenticationError.localizedDescription]];
             }
         });
     }];
}

@end
