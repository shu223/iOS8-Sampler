//
//  TTMMetalRenderer.h
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/09/17.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#if !TARGET_IPHONE_SIMULATOR
#import "AAPLView.h"
#import <Metal/Metal.h>
#endif


@interface TTMMetalRenderer : NSObject
#if !TARGET_IPHONE_SIMULATOR
<AAPLViewDelegate>
// renderer will create a default device at init time.
@property (nonatomic, readonly) id <MTLDevice> device;

// this value will cycle from 0 to g_max_inflight_buffers whenever a display completes ensuring renderer clients
// can synchronize between g_max_inflight_buffers count buffers, and thus avoiding a constant buffer from being overwritten between draws
@property (nonatomic, readonly) NSUInteger constantDataBufferIndex;

//  These queries exist so the View can initialize a framebuffer that matches the expectations of the renderer
@property (nonatomic, readonly) MTLPixelFormat depthPixelFormat;
@property (nonatomic, readonly) MTLPixelFormat stencilPixelFormat;
@property (nonatomic, readonly) NSUInteger sampleCount;

// load all assets before triggering rendering
- (void)configure:(AAPLView *)view;
#endif

@end
