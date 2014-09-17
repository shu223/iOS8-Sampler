/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information

 */

#import <string>

#import "AAPLPlasmaTypes.h"
#import "AAPLTransforms.h"
#import "AAPLPlasmaParams.h"
#import "AAPLPlasmaUniforms.h"

namespace AAPL
{
    namespace Plasma
    {
        static const uint32_t kCntVertUniformBuffer = 2;
        static const uint32_t kSzVertUniformBuffer  = kCntVertUniformBuffer * kSzVertUniforms;
        
        static const uint32_t kCntFragUniformBuffer = 2;
        static const uint32_t kSzFragUniformBuffer  = kCntFragUniformBuffer * kSzFragUniforms;
        
        static const uint32_t kMaxBufferBytesPerFrame = kSzVertUniformBuffer + kSzFragUniformBuffer;
        
        static const NSUInteger kMaxEncodes = 2;
        
        static const float kFOVY          = 65.0f;
        static const float kRotationDelta = 2.0f;
        
        static const simd::float3 kEye    = {0.0f, 0.0f, 0.0f};
        static const simd::float3 kCenter = {0.0f, 0.0f, 1.0f};
        static const simd::float3 kUp     = {0.0f, 1.0f, 0.0f};
    } // Plasma
} // AAPL

@implementation AAPLPlasmaUniforms
{
@private
    AAPL::Plasma::Params              m_Plasma[2];
    AAPL::Plasma::Uniforms::Vertex    m_VertUniforms[2];
    AAPL::Plasma::Uniforms::Fragment  m_FragUniforms[2];
    AAPL::Plasma::Transforms          m_Transforms;
    
    UIInterfaceOrientation  m_Orientation[2];
    
    NSMutableArray  *mpUniformBuffer;
    
    NSUInteger  mnCapacity;
    NSUInteger  mnMemBarrierIndex;
    NSUInteger  mnEncodeIndex;
    
    CGRect  _bounds;
}

@synthesize bounds;

- (instancetype) initWithDevice:(id <MTLDevice>)device
                       capacity:(NSUInteger)capacity
{
    self = [super init];
    
    if(self)
    {
        if(device)
        {
            // Set the total number of inflight buffers
            mnCapacity = capacity;
            
            // Create a mutable array to hold all the constant buffers
            mpUniformBuffer = [[NSMutableArray alloc] initWithCapacity:mnCapacity];
            
            if(!mpUniformBuffer)
            {
                NSLog(@">> ERROR: Failed creating a mutable array for uniform buffers!");
                
                return nil;
            } // if
            
            // allocate one region of memory for the constant buffer per max in
            // flight command buffers so that memory is properly syncronized.
            uint32_t i;
            
            id <MTLBuffer> buffer = nil;
            
            for(i = 0; i < mnCapacity; ++i)
            {
                // Create a new constant buffer
                buffer = [device newBufferWithLength:AAPL::Plasma::kMaxBufferBytesPerFrame
                                             options:0];
                
                
                if(!buffer)
                {
                    NSLog(@">> ERROR: Failed creating a new buffer[%d]!",i);
                    
                    break;
                } // if
                
                // Set a label for the constant buffer
                buffer.label = [NSString stringWithFormat:@"PlasmaConstantBuffer%i", i];
                
                // Add the constant buffer to the mutable array
                [mpUniformBuffer addObject:buffer];
            } // for
            
            if([mpUniformBuffer count] != mnCapacity)
            {
                NSLog(@">> ERROR: Failed creating all the requested buffers!");
                
                return nil;
            } // if
            
            std::memset(m_VertUniforms, 0x0, AAPL::Plasma::kSzVertUniformBuffer);
            std::memset(m_FragUniforms, 0x0, AAPL::Plasma::kSzFragUniformBuffer);
            
            m_FragUniforms[0].mnType = 1;
            m_FragUniforms[1].mnType = 2;
            
            m_Transforms.mnAspect   = 0.0f;
            m_Transforms.mnRotation = 0.0f;
            m_Transforms.mnFOVY     = AAPL::Plasma::kFOVY;
            
            m_Transforms.m_View      = AAPL::Math::lookAt(AAPL::Plasma::kEye, AAPL::Plasma::kCenter, AAPL::Plasma::kUp);
            m_Transforms.m_Model     = AAPL::Math::translate(0.0f, 0.0f, 7.0f);
            m_Transforms.m_ModelView = AAPL::Math::translate(0.0f, 0.0f, 1.5f);
            
            mnMemBarrierIndex = 0;
            mnEncodeIndex     = 0;
        } // if
    } // if
    
    return self;
} // initWithDevice

- (void) dealloc
{
    mpUniformBuffer = nil;
} // dealloc

- (BOOL) upload
{
    // Get the constant bufferm at index
    id <MTLBuffer> buffer = mpUniformBuffer[mnMemBarrierIndex];
    
    if(!buffer)
    {
        NSLog(@">> ERROR: Failed to get the constant buffer[%lu]!",mnMemBarrierIndex);
        
        return NO;
    } // if
    
    // Get the base address of the constant buffer
    uint8_t *pBufferPointer = (uint8_t *)[buffer contents];
    
    if(!pBufferPointer)
    {
        NSLog(@">> ERROR: Failed to get the constant buffer[%lu] pointer!",mnMemBarrierIndex);
        
        return NO;
    } // if
    
    // Copy the updated linear transformations for both cubes into the constant vertex buffer
    std::memcpy(pBufferPointer, m_VertUniforms, AAPL::Plasma::kSzVertUniformBuffer);
    
    // Increment the buffer pointer to where we can write fragment constant data
    pBufferPointer += AAPL::Plasma::kSzVertUniformBuffer;
    
    // Copy scale and time factors for both cubes into the constant fragment buffer
    std::memcpy(pBufferPointer, m_FragUniforms, AAPL::Plasma::kSzFragUniformBuffer);
    
    return YES;
} // upload

- (void) _encode:(id <MTLRenderCommandEncoder>)renderEncoder
          offset:(AAPL::Offset)offset
{
    [renderEncoder setVertexBuffer:mpUniformBuffer[mnMemBarrierIndex]
                            offset:offset.x
                           atIndex:3 ];
    
    [renderEncoder setFragmentBuffer:mpUniformBuffer[mnMemBarrierIndex]
                              offset:AAPL::Plasma::kSzVertUniformBuffer + offset.y
                             atIndex:0 ];
} // _encode

- (void) encode:(id <MTLRenderCommandEncoder>)renderEncoder
{
    AAPL::Offset offset = {0, 0};
    
    if(mnEncodeIndex == 0)
    {
        [self _encode:renderEncoder
               offset:offset];
    }
    else if(mnEncodeIndex == 1)
    {
        offset.x = AAPL::Plasma::kSzVertUniforms;
        offset.y = AAPL::Plasma::kSzFragUniforms;
        
        [self _encode:renderEncoder
               offset:offset];
        
        // Increment the memory barrier index
        mnMemBarrierIndex = (mnMemBarrierIndex + 1) % mnCapacity;
    }
    
    mnEncodeIndex = (mnEncodeIndex + 1) % AAPL::Plasma::kMaxEncodes;
} // encode

- (void) setBounds:(CGRect)inBounds
{
    // To correctly compute the aspect ratio determine the device
    // interface orientation.
    m_Orientation[0] = [UIApplication sharedApplication].statusBarOrientation;
    
    if(m_Orientation[0] != m_Orientation[1])
    {
        // Set the bounds
        _bounds = inBounds;
        
        // Get the bounds for the current rendering layer
        m_Transforms.mnAspect     = std::abs(_bounds.size.width / _bounds.size.height);
        m_Transforms.m_Projection = AAPL::Math::perspective_fov(m_Transforms.mnFOVY, m_Transforms.mnAspect, 0.1f, 100.0f);
        
        m_VertUniforms[0].m_Projection = m_Transforms.m_Projection;
        m_VertUniforms[1].m_Projection = m_Transforms.m_Projection;
        
        m_Orientation[1] = m_Orientation[0];
    } // if
} // setBounds

- (void) update
{
    simd::float4x4 rotate        = AAPL::Math::rotate(m_Transforms.mnRotation, 0.0f, 1.0f, 0.0f);
    simd::float4x4 model         = m_Transforms.m_Model * rotate;
    simd::float4x4 modelViewBase = m_Transforms.m_View * model;
    
    rotate = AAPL::Math::rotate(m_Transforms.mnRotation, 1.0f, 1.0f, 1.0f);
    
    simd::float4x4 modelView = m_Transforms.m_ModelView * rotate;
    
    modelView = modelViewBase * modelView;
    
    // Set the mode-view matrix for the primary vertex constant buffer
    m_VertUniforms[0].m_ModelView = modelView;
    
    modelView = AAPL::Math::translate(0.0f, 0.0f, -1.5f);
    modelView = modelView * rotate;
    modelView = modelViewBase * modelView;
    
    // Set the mode-view matrix for the second vertex constant buffer
    m_VertUniforms[1].m_ModelView = modelView;
    
    // update rotation
    m_Transforms.mnRotation += AAPL::Plasma::kRotationDelta;
    
    // Update the plasma animation
    AAPL::Vector2 v = m_Plasma[0].update();
    
    m_FragUniforms[0].mnTime  = v.time;
    m_FragUniforms[0].mnScale = v.scale;
    
    AAPL::Vector2 w = m_Plasma[1].update();
    
    m_FragUniforms[1].mnTime  = w.time;
    m_FragUniforms[1].mnScale = w.scale;
} // update

@end
