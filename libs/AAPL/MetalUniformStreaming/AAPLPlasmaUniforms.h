/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  Plasma shader uniforms encapsulated utility class.
  
 */

#import <UIKit/UIKit.h>
#import <Metal/Metal.h>

@interface AAPLPlasmaUniforms : NSObject

@property (nonatomic, readwrite) CGRect bounds;

- (instancetype) initWithDevice:(id <MTLDevice>)device
                       capacity:(NSUInteger)capacity;

- (void) encode:(id <MTLRenderCommandEncoder>)renderEncoder;

- (BOOL) upload;

- (void) update;

@end
