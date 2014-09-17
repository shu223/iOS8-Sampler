//
//  CommonButton.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/08/18.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "CommonButton.h"


@implementation CommonButton

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.layer.cornerRadius = 2.0;

    self.backgroundColor = COMMON_BLUE_COLOR;
    
    self.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:self.titleLabel.font.pointSize];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

@end
