/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  3d cube vertices, normals, texture coordinates, and indices.
  
 */

#import <Metal/Metal.h>

#import "AAPLTypes.h"

@interface AAPLCube : NSObject

// Indices
@property (nonatomic, readwrite) NSUInteger  vertexIndex;
@property (nonatomic, readwrite) NSUInteger  normalIndex;
@property (nonatomic, readwrite) NSUInteger  texCoordIndex;

// Dimensions
@property (nonatomic, readwrite) float          length;
@property (nonatomic, readwrite) AAPL::Vector3  size;

// Designated initializers
- (instancetype) initWithDevice:(id <MTLDevice>)device
                         length:(float)length;

- (instancetype) initWithDevice:(id <MTLDevice>)device
                           size:(AAPL::Vector3)size;


// Encode buffers
- (void) encode:(id <MTLRenderCommandEncoder>)renderEncoder;

// Draw the IBO
- (void) draw:(id <MTLRenderCommandEncoder>)renderEncoder;

@end
