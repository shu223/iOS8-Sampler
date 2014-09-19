//
//  RubyAnnotationLabel.h
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/09/19.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//
//  Thanks to:
//  http://nshipster.com/ios8/
//  http://dev.classmethod.jp/references/ios8-ctrubyannotationref/


#import <UIKit/UIKit.h>

@interface RubyAnnotationLabel : UIView

- (void)setText:(NSString *)text withFurigana:(NSString *)furigana;

@end
