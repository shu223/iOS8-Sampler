//
//  MetalUniformStreamRenderer.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/09/17.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//
//  Based on Apple's sample code:
//  https://developer.apple.com/library/prerelease/ios/samplecode/MetalUniformStreaming/


#import "MetalUniformStreamRenderer.h"
#import <TargetConditionals.h>
#if !TARGET_IPHONE_SIMULATOR
#import "AAPLCube.h"
#import "AAPLPlasmaUniforms.h"
#endif


static const uint32_t kInFlightCommandBuffers = 3;


@implementation MetalUniformStreamRenderer
#if !TARGET_IPHONE_SIMULATOR
{
@private
    id <MTLDevice> _device;
    MTLPixelFormat _depthPixelFormat;
    MTLPixelFormat _stencilPixelFormat;
    NSUInteger     _sampleCount;
    
    AAPLCube            *mpCube;
    AAPLPlasmaUniforms  *mpPlasmaUniforms;
    
    id <MTLCommandQueue>         m_CommandQueue;
    id <MTLLibrary>              m_ShaderLibrary;
    id <MTLDepthStencilState>    m_DepthState;
    id <MTLRenderPipelineState>  m_PipelineState;
    
    dispatch_semaphore_t  m_InflightSemaphore;
}

- (void) cleanup
{
    // Private
    m_PipelineState  = nil;
    m_DepthState     = nil;
    m_ShaderLibrary  = nil;
    m_CommandQueue   = nil;
    mpPlasmaUniforms = nil;
    mpCube           = nil;
}

- (instancetype) init
{
    self = [super init];
    
    if(self)
    {
        // Set the default pixel sample count
        _sampleCount = 4;
        
        // Set the default pixel formats
        _depthPixelFormat   = MTLPixelFormatDepth32Float;
        _stencilPixelFormat = MTLPixelFormatInvalid;
        
        // find a usable Device
        _device = MTLCreateSystemDefaultDevice();
        if(!_device)
        {
            NSLog(@">> ERROR: Failed creating a default system device!");
            
            exit(-1);
        } // if
        
        // load offline compiled shaders
        m_ShaderLibrary = [_device newDefaultLibrary];
        if(!m_ShaderLibrary)
        {
            NSLog(@">> ERROR: Failed creating a new library!");
            
            assert(0);
        } // if
        
        // setup a semaphore to synchronize between command buffer encoding and submission
        m_InflightSemaphore = dispatch_semaphore_create(kInFlightCommandBuffers);
    }
    
    return self;
} // init

#pragma mark - Configure

- (void) configure:(AAPLView *)view
{
    //configure the view with teh same pixel format and sample count used for the pipeline state object
    view.depthPixelFormat   = _depthPixelFormat;
    view.stencilPixelFormat = _stencilPixelFormat;
    view.sampleCount        = _sampleCount;
    
    // create a new command queue
    m_CommandQueue = [_device newCommandQueue];
    
    if(![self preparePipelineState])
    {
        NSLog(@">> ERROR: Failed creating a depth stencil state descriptor!");
        
        // if we dont have a valid compiled pieline state object, something went seriously wrong
        assert(0);
    }
    
    // setup content
    if(![self setupContent])
    {
        NSLog(@">> ERROR: Failed loading the assets!");
        
        exit(-1);
    }
} // configure

- (BOOL) preparePipelineState
{
    // load the vertex program into the library
    id <MTLFunction> vertexProgram = [m_ShaderLibrary newFunctionWithName:@"plasmaVertex"];
    
    if(!vertexProgram)
    {
        NSLog(@">> ERROR: Failed creating a new vertex program!");
        
        return NO;
    } // if
    
    // load the fragment program into the library
    id <MTLFunction> fragmentProgram = [m_ShaderLibrary newFunctionWithName:@"plasmaFragment"];
    
    if(!fragmentProgram)
    {
        NSLog(@">> ERROR: Failed creating a new fragment program!");
        
        return NO;
    } // if
    
    // Create a reusable pipeline state
    MTLRenderPipelineDescriptor *pPipelineStateDescriptor = [MTLRenderPipelineDescriptor new];
    
    if(!pPipelineStateDescriptor)
    {
        NSLog(@">> ERROR: Failed creating a new pipeline state descriptor!");
        
        return NO;
    } // if
    
    pPipelineStateDescriptor.depthAttachmentPixelFormat      = _depthPixelFormat;
    pPipelineStateDescriptor.stencilAttachmentPixelFormat    = _stencilPixelFormat;
    pPipelineStateDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
    
    pPipelineStateDescriptor.sampleCount      = _sampleCount;
    pPipelineStateDescriptor.vertexFunction   = vertexProgram;
    pPipelineStateDescriptor.fragmentFunction = fragmentProgram;
    
    NSError  *pError = nil;
    
    m_PipelineState = [_device newRenderPipelineStateWithDescriptor:pPipelineStateDescriptor
                                                              error:&pError];
    
    if(!m_PipelineState)
    {
        NSLog(@">> ERROR: Failed creating a new render pipeline state descriptor: %@", pError);
        
        return NO;
    } // if
    
    return YES;
} // preparePipelineState

- (BOOL) prepareDepthState
{
    MTLDepthStencilDescriptor *pDepthStateDesc = [MTLDepthStencilDescriptor new];
    
    if(!pDepthStateDesc)
    {
        NSLog(@">> ERROR: Failed creating a depth stencil descriptor!");
        
        return NO;
    } // if
    
    pDepthStateDesc.depthCompareFunction = MTLCompareFunctionLess;
    pDepthStateDesc.depthWriteEnabled    = YES;
    
    m_DepthState = [_device newDepthStencilStateWithDescriptor:pDepthStateDesc];
    
    if(!m_DepthState)
    {
        return NO;
    } // if
    
    return YES;
} // prepareDepthState

- (BOOL) setupContent
{
    // Create 3d cube with fixed dimensions
    AAPL::Vector3 size = {0.75f, 0.75f, 0.75f};
    
    mpCube = [[AAPLCube alloc] initWithDevice:_device
                                         size:size];
    
    if(!mpCube)
    {
        NSLog(@">> ERROR: Failed creating 3d cube!");
        
        return NO;
    } // if
    
    // allocate one region of memory for the constant buffer per max in
    // flight command buffers so that memory is properly syncronized.
    mpPlasmaUniforms = [[AAPLPlasmaUniforms alloc] initWithDevice:_device
                                                         capacity:kInFlightCommandBuffers];
    
    if(!mpPlasmaUniforms)
    {
        NSLog(@">> ERROR: Failed creating plasma constants!");
        
        return NO;
    } // if
    
    if(![self prepareDepthState])
    {
        NSLog(@">> ERROR: Failed creating a depth stencil!");
        
        return NO;
    } // if
    
    return YES;
} // configure

#pragma mark render

- (void) encode:(id <MTLRenderCommandEncoder>)renderEncoder
{
    // Set context state with the render encoder
    [renderEncoder pushDebugGroup:@"plasma cubes"];
    [renderEncoder setDepthStencilState:m_DepthState];
    [renderEncoder setRenderPipelineState:m_PipelineState];
    
    // Encode a 3d cube into renderer
    [mpCube encode:renderEncoder];
    
    // Encode into renderer the first set of vertex and fragment uniforms
    [mpPlasmaUniforms encode:renderEncoder];
    
    // Tell the render context we want to draw our first set of primitives
    [mpCube draw:renderEncoder];
    
    // Encode into renderer the second set of vertex and fragment uniforms
    [mpPlasmaUniforms encode:renderEncoder];
    
    // Tell the render context we want to draw our second set of primitives
    [mpCube draw:renderEncoder];
    
    // The encoding is now complete
    [renderEncoder endEncoding];
    [renderEncoder popDebugGroup];
} // encode

- (void) render:(AAPLView *)view
{
    // Wait on semaphore
    dispatch_semaphore_wait(m_InflightSemaphore, DISPATCH_TIME_FOREVER);
    
    // Upload the uniforms into the structure bound to shaders
    [mpPlasmaUniforms upload];
    
    // Acquire a command buffer
    id <MTLCommandBuffer> commandBuffer = [m_CommandQueue commandBuffer];
    
    MTLRenderPassDescriptor *renderPassDescriptor = view.renderPassDescriptor;
    if (renderPassDescriptor)
    {
        // Get a render encoder
        id <MTLRenderCommandEncoder>  renderEncoder
        = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        
        // Encode into a renderer
        [self encode:renderEncoder];
        
        // Call the view's completion handler which is required by the view
        // since it will signal its semaphore and set up the next buffer
        __block dispatch_semaphore_t dispatchSemaphore = m_InflightSemaphore;
        
        [commandBuffer addCompletedHandler:^(id <MTLCommandBuffer> cmdb){
            dispatch_semaphore_signal(dispatchSemaphore);
        }];
        
        // Schedule a present once the framebuffer is complete
        [commandBuffer presentDrawable:view.currentDrawable];
        
        // Finalize rendering here & push the command buffer to the GPU
        [commandBuffer commit];
    }
    else
    {
        dispatch_semaphore_signal(m_InflightSemaphore);
    }
} // render

- (void) reshape:(AAPLView *)view
{
    mpPlasmaUniforms.bounds = view.bounds;
} // reshape

- (void) update
{
    [mpPlasmaUniforms update];
} // update
#endif

@end
