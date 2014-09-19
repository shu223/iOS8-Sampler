//
//  RubyAnnotationViewController.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/09/19.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//
//  Thanks to:
//  http://nshipster.com/ios8/
//  http://dev.classmethod.jp/references/ios8-ctrubyannotationref/


#import "RubyAnnotationViewController.h"
#import "RubyAnnotationLabel.h"


@interface RubyAnnotationViewController ()
@property (nonatomic, weak) IBOutlet RubyAnnotationLabel *label;
@end


@implementation RubyAnnotationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];


    [self.label setText:@"林檎" withFurigana:@"りんご"];
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

@end
