//
//  UIAlertController (TTMAppearance)
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/08/19.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "UIAlertController+TTMAppearance.h"


@implementation UIAlertController (TTMAppearance)

// =============================================================================
#pragma mark - Private

- (void)changeTitleForView:(UIView *)view
              withFontName:(NSString *)fontName
{
    for (UIView *aSubview in view.subviews) {
        if ([aSubview isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)aSubview;
            label.font = [UIFont fontWithName:fontName size:label.font.pointSize];
        }
        else {
            [self changeTitleForView:aSubview withFontName:fontName];
        }
    }
}

- (void)changeTitleForView:(UIView *)view
                  withFont:(UIFont *)font
{
    for (UIView *aSubview in view.subviews) {
        if ([aSubview isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)aSubview;
            label.font = font;
        }
        else {
            [self changeTitleForView:aSubview withFont:font];
        }
    }
}


// =============================================================================
#pragma mark - Public

- (void)changeTitleFontWithName:(NSString *)fontName {
    
    [self changeTitleForView:self.view withFontName:fontName];
}

- (void)changeTitleFont:(UIFont *)font {
    
    [self changeTitleForView:self.view withFont:font];
}

@end
