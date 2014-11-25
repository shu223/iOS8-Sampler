//
//  RowActionViewController.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/11/25.
//  Copyright (c) 2014年 Shuichi Tsutsumi. All rights reserved.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



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
    }

    cell.textLabel.text = self.items[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *destructiveAction;
    UITableViewRowAction *normalAction;

    destructiveAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                           title:@"destructive"
                                                         handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                             [SVProgressHUD showSuccessWithStatus:@"Destructive action has been executed!"];
                                                         }];

    normalAction      = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                           title:@"normal"
                                                         handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                             [SVProgressHUD showSuccessWithStatus:@"Normal action has been executed!"];
                                                         }];

    return @[destructiveAction, normalAction];
}


// =============================================================================
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
