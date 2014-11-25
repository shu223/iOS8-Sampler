//
//  SeparatorEffectViewController.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/11/25.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "SeparatorEffectViewController.h"


@interface SeparatorEffectViewController ()
<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedCtl;
@property (nonatomic, weak) IBOutlet UISwitch *vibrancySwitch;
@property (nonatomic, strong) NSArray *items;
@end


@implementation SeparatorEffectViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.items = @[
                   @"Cell1",
                   @"Cell2",
                   @"Cell3",
                   @"Cell4",
                   @"Cell5",
                   @"Cell6",
                   @"Cell7",
                   @"Cell8",
                   @"Cell9",
                   @"Cell10",
                   @"Cell11",
                   @"Cell12",
                   @"Cell13",
                   @"Cell14",
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
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }

    cell.textLabel.text = self.items[indexPath.row];
    
    return cell;
}


// =============================================================================
#pragma mark - Private

- (void)updateSeparatorEffect {

    UIBlurEffect *blurEffect;
    
    switch (self.segmentedCtl.selectedSegmentIndex) {
        case 0:
        default:
            // effect is nil
            break;
            
        case 1:
        {
            blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            break;
        }
        case 2:
            blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            break;
            
        case 3:
            blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            break;
    }
    
    if ([self.vibrancySwitch isOn]) {
        self.tableView.separatorEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    }
    else {
        self.tableView.separatorEffect = blurEffect;
    }
}


// =============================================================================
#pragma mark - IBAction

- (IBAction)segmentChanged:(UISegmentedControl *)sender {
    
    [self updateSeparatorEffect];
}

- (IBAction)vibrancySwitchChaged:(id)sender {
    
    [self updateSeparatorEffect];
}

@end
