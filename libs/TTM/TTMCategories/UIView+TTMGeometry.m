//
//  UIView+TTMGeometry.m
//
//  Created by shuichi on 7/19/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "UIView+TTMGeometry.h"

@implementation UIView (TTMGeometry)

- (CGFloat)x {
    
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)value {
    
    self.frame = CGRectMake(value, self.y, self.width, self.height);
}

- (CGFloat)y {

    return self.frame.origin.y;
}

- (void)setY:(CGFloat)value {
    
    self.frame = CGRectMake(self.x, value, self.width, self.height);
}

- (CGPoint)origin {
    
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    
    self.frame = CGRectMake(origin.x, origin.y, self.width, self.height);
}

- (CGFloat)width {

    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)value {

    self.frame = CGRectMake(self.x, self.y, value, self.height);
}

- (CGFloat)height {

    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)value {

    self.frame = CGRectMake(self.x, self.y, self.width, value);
}

- (CGSize)size {
    
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    
    self.frame = CGRectMake(self.x, self.y, size.width, size.height);
}

- (CGFloat)bottom {
    
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)value {
    
    self.frame = CGRectMake(self.x, value - self.height, self.width, self.height);
}

- (CGFloat)right {
    
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)value {
    
    self.frame = CGRectMake(value - self.width, self.y, self.width, self.height);
}

@end
