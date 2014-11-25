//
//  RowActionViewController.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/11/25.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "RowActionViewController.h"
#import "SVProgressHUD.h"


@interface RowActionViewController ()
<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *items;
@end


@implementation RowActionViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.items = @[
                   @"Swipe this cell",
                   ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// =============================================================================
#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }

    cell.textLabel.text = self.items[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *destructive;
    UITableViewRowAction *normal;
    UITableViewRowAction *customized1;
    UITableViewRowAction *customized2;


    destructive = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                           title:@"dest"
                                                         handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                             [SVProgressHUD showSuccessWithStatus:@"Destructive action has been executed!"];
                                                         }];

    normal      = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                           title:@"norm"
                                                         handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                             [SVProgressHUD showSuccessWithStatus:@"Normal action has been executed!"];
                                                         }];

    customized1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                           title:@"cus1"
                                                         handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                             [SVProgressHUD showSuccessWithStatus:@"An action (customized from default) has been executed!"];
                                                         }];
    customized1.backgroundColor = [UIColor greenColor];

    customized2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                           title:@"cus2"
                                                         handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                             [SVProgressHUD showSuccessWithStatus:@"An action (customized from default) has been executed!"];
                                                         }];
    customized2.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];

    return @[destructive,
             normal,
             customized1,
             customized2];
}


// =============================================================================
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
