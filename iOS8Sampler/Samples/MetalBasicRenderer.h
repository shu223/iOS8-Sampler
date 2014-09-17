//
//  MetalBasicRenderer.h
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/09/17.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//
//

#import "TTMMetalRenderer.h"


@interface MetalBasicRenderer : TTMMetalRenderer

- (void)updateRotationWithTimeSinceLastDraw:(NSTimeInterval)timeSinceLastDraw;

@end
