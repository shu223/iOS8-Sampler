//
//  UserNotificationViewController.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/09/08.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "UserNotificationViewController.h"
#import "SVProgressHUD.h"


NSString * const kInviteCategoryIdentifier = @"INVITE_CATEGORY";


@interface UserNotificationViewController ()

@end



@implementation UserNotificationViewController

- (void)viewDidLoad {

    [super viewDidLoad];


    // create actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    acceptAction.activationMode = UIUserNotificationActivationModeBackground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;   // If YES requires passcode, but does not unlock the device

    UIMutableUserNotificationAction *declineAction = [[UIMutableUserNotificationAction alloc] init];
    declineAction.identifier = @"DECLINE_IDENTIFIER";
    declineAction.title = @"Decline";
    acceptAction.activationMode = UIUserNotificationActivationModeBackground;
    declineAction.destructive = YES;
    acceptAction.authenticationRequired = NO;

    // create a category
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    inviteCategory.identifier = kInviteCategoryIdentifier;
    [inviteCategory setActions:@[acceptAction, declineAction]
                    forContext:UIUserNotificationActionContextDefault];
    [inviteCategory setActions:@[acceptAction, declineAction]
                    forContext:UIUserNotificationActionContextMinimal];

    // registration
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
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

- (IBAction)scheduleBtnTapped:(id)sender {

    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [[NSDate date] dateByAddingTimeInterval:15.0];
    notification.alertBody = @"This is Local Notification from iOS8-Sampler";
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.category = kInviteCategoryIdentifier;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    
    [SVProgressHUD showSuccessWithStatus:@"A local notification has been scheduled. Please wait 15 sec with sleep mode."];

    // Actions can be handled in AppDelegate.
}

@end
