//
//  MetalBasicRenderer.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/09/17.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//
//  Based on Apple's sample code:
//  https://developer.apple.com/library/prerelease/ios/samplecode/MetalBasic3D/


#import "MetalBasicRenderer.h"
#import "AAPLTransforms.h"
#import "AAPLSharedTypes.h"

using namespace AAPL;
using namespace simd;

static const long kInFlightCommandBuffers = 3;

static const NSUInteger kNumberOfBoxes = 250;
static const float4 kBoxAmbientColors[2] = {
    {0.18, 0.24, 0.8, 1.0},
    {0.8, 0.24, 0.1, 1.0}
};

static const float4 kBoxDiffuseColors[2] = {
    {0.4, 0.4, 1.0, 1.0},
    {0.8, 0.4, 0.4, 1.0}
};

static const float kRadius  = 5.0f;
static const float kTheta   = 180.0f;
static const float kPhi     = 360.0f;

static const float kFOVY    = 65.0f;
static const float3 kEye    = {0.0f, 0.0f, 0.0f};
static const float3 kCenter = {0.0f, 0.0f, 1.0f};
static const float3 kUp     = {0.0f, 1.0f, 0.0f};

static const float kWidth  = 0.05f;
static const float kHeight = 0.05f;
static const float kDepth  = 0.05f;

static const float kCubeVertexData[] =
{
    kWidth, -kHeight, kDepth,   0.0, -1.0,  0.0,
    -kWidth, -kHeight, kDepth,   0.0, -1.0, 0.0,
    -kWidth, -kHeight, -kDepth,   0.0, -1.0,  0.0,
    kWidth, -kHeight, -kDepth,  0.0, -1.0,  0.0,
    kWidth, -kHeight, kDepth,   0.0, -1.0,  0.0,
    -kWidth, -kHeight, -kDepth,   0.0, -1.0,  0.0,
    
    kWidth, kHeight, kDepth,    1.0, 0.0,  0.0,
    kWidth, -kHeight, kDepth,   1.0,  0.0,  0.0,
    kWidth, -kHeight, -kDepth,  1.0,  0.0,  0.0,
    kWidth, kHeight, -kDepth,   1.0, 0.0,  0.0,
    kWidth, kHeight, kDepth,    1.0, 0.0,  0.0,
    kWidth, -kHeight, -kDepth,  1.0,  0.0,  0.0,
    
    -kWidth, kHeight, kDepth,    0.0, 1.0,  0.0,
    kWidth, kHeight, kDepth,    0.0, 1.0,  0.0,
    kWidth, kHeight, -kDepth,   0.0, 1.0,  0.0,
    -kWidth, kHeight, -kDepth,   0.0, 1.0,  0.0,
    -kWidth, kHeight, kDepth,    0.0, 1.0,  0.0,
    kWidth, kHeight, -kDepth,   0.0, 1.0,  0.0,
    
    -kWidth, -kHeight, kDepth,  -1.0,  0.0, 0.0,
    -kWidth, kHeight, kDepth,   -1.0, 0.0,  0.0,
    -kWidth, kHeight, -kDepth,  -1.0, 0.0,  0.0,
    -kWidth, -kHeight, -kDepth,  -1.0,  0.0,  0.0,
    -kWidth, -kHeight, kDepth,  -1.0,  0.0, 0.0,
    -kWidth, kHeight, -kDepth,  -1.0, 0.0,  0.0,
    
    kWidth, kHeight,  kDepth,  0.0, 0.0,  1.0,
    -kWidth, kHeight,  kDepth,  0.0, 0.0,  1.0,
    -kWidth, -kHeight, kDepth,   0.0,  0.0, 1.0,
    -kWidth, -kHeight, kDepth,   0.0,  0.0, 1.0,
    kWidth, -kHeight, kDepth,   0.0,  0.0,  1.0,
    kWidth, kHeight,  kDepth,  0.0, 0.0,  1.0,
    
    kWidth, -kHeight, -kDepth,  0.0,  0.0, -1.0,
    -kWidth, -kHeight, -kDepth,   0.0,  0.0, -1.0,
    -kWidth, kHeight, -kDepth,  0.0, 0.0, -1.0,
    kWidth, kHeight, -kDepth,  0.0, 0.0, -1.0,
    kWidth, -kHeight, -kDepth,  0.0,  0.0, -1.0,
    -kWidth, kHeight, -kDepth,  0.0, 0.0, -1.0
};


@implementation MetalBasicRenderer
#if !TARGET_IPHONE_SIMULATOR
{
    // constant synchronization for buffering <kInFlightCommandBuffers> frames
    dispatch_semaphore_t _inflight_semaphore;
    id <MTLBuffer> _dynamicConstantBuffer[kInFlightCommandBuffers];
    
    // renderer global ivars
    id <MTLDevice> _device;
    id <MTLCommandQueue> _commandQueue;
    id <MTLLibrary> _defaultLibrary;
    id <MTLRenderPipelineState> _pipelineState;
    id <MTLBuffer> _vertexBuffer;
    id <MTLDepthStencilState> _depthState;
    
    // globals used in update calculation
    float4x4 _projectionMatrix;
    float4x4 _viewMatrix;
    float4x4 _baseModelMatrix[kNumberOfBoxes];
    float _rotation;
    
    long _maxBufferBytesPerFrame;
    size_t _sizeOfConstantT;
}
@synthesize sampleCount = _sampleCount;
@synthesize depthPixelFormat = _depthPixelFormat;
@synthesize stencilPixelFormat = _stencilPixelFormat;
@synthesize device = _device;
@synthesize constantDataBufferIndex = _constantDataBufferIndex;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _sizeOfConstantT = sizeof(constants_t);
        _maxBufferBytesPerFrame = _sizeOfConstantT*kNumberOfBoxes;
        _sampleCount = 1;
        _depthPixelFormat = MTLPixelFormatDepth32Float;
        _stencilPixelFormat = MTLPixelFormatInvalid;
        
        // find a usable Device
        _device = MTLCreateSystemDefaultDevice();
        
        // create a new command queue
        _commandQueue = [_device newCommandQueue];
        
        _defaultLibrary = [_device newDefaultLibrary];
        if(!_defaultLibrary) {
            NSLog(@">> ERROR: Couldnt create a default shader library");
            // assert here becuase if the shader libary isn't loading, nothing good will happen
            assert(0);
        }
        
        _constantDataBufferIndex = 0;
        _inflight_semaphore = dispatch_semaphore_create(kInFlightCommandBuffers);
    }
    return self;
}

#pragma mark Render

- (void)render:(AAPLView *)view
{
    dispatch_semaphore_wait(_inflight_semaphore, DISPATCH_TIME_FOREVER);
    
    [self update];
    
    // create a new command buffer for each renderpass to the current drawable
    id <MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    
    // create a render command encoder so we can render into something
    MTLRenderPassDescriptor *renderPassDescriptor = view.renderPassDescriptor;
    if (renderPassDescriptor)
    {
        id <MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        [renderEncoder pushDebugGroup:@"Boxes"];
        [renderEncoder setDepthStencilState:_depthState];
        [renderEncoder setRenderPipelineState:_pipelineState];
        [renderEncoder setVertexBuffer:_vertexBuffer offset:0 atIndex:0 ];
        
        // NOTE: this could be alot faster if we render using instancing, but in this case we want to emit lots of draw calls
        for (int i = 0; i < kNumberOfBoxes; i++) {
            //  set constant buffer for each box
            [renderEncoder setVertexBuffer:_dynamicConstantBuffer[_constantDataBufferIndex] offset:i*_sizeOfConstantT atIndex:1 ];
            
            // tell the render context we want to draw our primitives
            [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:36 instanceCount:1];
        }
        
        [renderEncoder endEncoding];
        [renderEncoder popDebugGroup];
        
        // call the view's completion handler which is required by the view since it will signal its semaphore and set up the next buffer
        __block dispatch_semaphore_t block_sema = _inflight_semaphore;
        [commandBuffer addCompletedHandler:^(id<MTLCommandBuffer> buffer) {
            dispatch_semaphore_signal(block_sema);
        }];
        
        // schedule a present once rendering to the framebuffer is complete
        [commandBuffer presentDrawable:view.currentDrawable];
        
        // finalize rendering here. this will push the command buffer to the GPU
        [commandBuffer commit];
    }
    else
    {
        // release the semaphore to keep things synchronized even if we couldnt render
        dispatch_semaphore_signal(_inflight_semaphore);
    }
    
    // the renderview assumes it can now increment the buffer index and that the previous index won't be touched
    // until we cycle back around to the same index
    _constantDataBufferIndex = (_constantDataBufferIndex + 1) % kInFlightCommandBuffers;
}

- (void)reshape:(AAPLView *)view
{
    // when reshape is called, update the view and projection matricies since this means the view orientation or size changed
    float aspect = fabsf(view.bounds.size.width / view.bounds.size.height);
    _projectionMatrix = perspective_fov(kFOVY, aspect, 0.1f, 100.0f);
    _viewMatrix = lookAt(kEye, kCenter, kUp);
}

#pragma mark Update

// only called at setup time
- (void)prepareTransforms
{
    for (int i = 0; i < kNumberOfBoxes; i++)
    {
        // calculate x,y,z position for translation matrix using spherical coordinate system
        // place somewhere in a helix
        float pos = (float((i+1)*2.0)/kNumberOfBoxes);
        float t = radians(kTheta * pos);
        float p = radians(kPhi * pos);
        float x = kRadius*cos(t)*sin(p);
        float y = kRadius*sin(t)*sin(p);
        float z = kRadius*cos(t);
        
        // translate to a viewable position on the screen
        _baseModelMatrix[i] = translate(x, y, z) * translate(0.0f, 0.0f, 15.0f);
    }
}

// called every frame
- (void)update
{
    constants_t *constant_buffer = (constants_t *)[_dynamicConstantBuffer[_constantDataBufferIndex] contents];
    for (int i = 0; i < kNumberOfBoxes; i++)
    {
        // calculate the Model view projection matrix of each box
        float4x4 modelViewMatrix = _baseModelMatrix[i] * rotate(_rotation, 1.0f, 1.0f, 1.0f);
        modelViewMatrix = _viewMatrix * modelViewMatrix;
        constant_buffer[i].normal_matrix = inverse(transpose(modelViewMatrix));
        constant_buffer[i].modelview_projection_matrix = _projectionMatrix * modelViewMatrix;
        
        // change the color each frame
        // reverse direction if we've reached a boundary
        if (constant_buffer[i].ambient_color.y >= 0.8) {
            constant_buffer[i].multiplier = -1;
            constant_buffer[i].ambient_color.y = 0.79;
        } else if (constant_buffer[i].ambient_color.y <= 0.2) {
            constant_buffer[i].multiplier = 1;
            constant_buffer[i].ambient_color.y = 0.21;
        } else
        constant_buffer[i].ambient_color.y += constant_buffer[i].multiplier * 0.0001*i;
    }
}


// =============================================================================
#pragma mark - Public

- (void)configure:(AAPLView *)view
{
    view.depthPixelFormat   = _depthPixelFormat;
    view.stencilPixelFormat = _stencilPixelFormat;
    view.sampleCount        = _sampleCount;
    
    // allocate a number of buffers in memory that matches the sempahore count so that
    // we always have one self contained memory buffer for each buffered frame.
    // In this case triple buffering is the optimal way to go so we cycle through 3 memory buffers
    for (int i = 0; i < kInFlightCommandBuffers; i++)
    {
        _dynamicConstantBuffer[i] = [_device newBufferWithLength:_maxBufferBytesPerFrame options:0];
        _dynamicConstantBuffer[i].label = [NSString stringWithFormat:@"ConstantBuffer%i", i];
        
        // write initial color values for both cubes (at each offset).
        // Note, these will get animated during update
        constants_t *constant_buffer = (constants_t *)[_dynamicConstantBuffer[i] contents];
        for (int j = 0; j < kNumberOfBoxes; j++)
        {
            if (j%2==0) {
                constant_buffer[j].multiplier = 1;
                constant_buffer[j].ambient_color = kBoxAmbientColors[0];
                constant_buffer[j].diffuse_color = kBoxDiffuseColors[0];
            }
            else {
                constant_buffer[j].multiplier = -1;
                constant_buffer[j].ambient_color = kBoxAmbientColors[1];
                constant_buffer[j].diffuse_color = kBoxDiffuseColors[1];
            }
        }
    }
    
    // preload initial transformation data once the constant buffers are setup
    [self prepareTransforms];
    
    // get the fragment function from the library
    id <MTLFunction> fragmentProgram = [_defaultLibrary newFunctionWithName:@"lighting_fragment"];
    if(!fragmentProgram)
    NSLog(@">> ERROR: Couldn't load fragment function from default library");
    
    // get the vertex function from the library
    id <MTLFunction> vertexProgram = [_defaultLibrary newFunctionWithName:@"lighting_vertex"];
    if(!vertexProgram)
    NSLog(@">> ERROR: Couldn't load vertex function from default library");
    
    // setup the vertex buffers
    _vertexBuffer = [_device newBufferWithBytes:kCubeVertexData length:sizeof(kCubeVertexData) options:MTLResourceOptionCPUCacheModeDefault];
    _vertexBuffer.label = @"Vertices";
    
    // create a pipeline state descriptor which can be used to create a compiled pipeline state object
    MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
    
    pipelineStateDescriptor.label                           = @"MyPipeline";
    pipelineStateDescriptor.sampleCount                     = _sampleCount;
    pipelineStateDescriptor.vertexFunction                  = vertexProgram;
    pipelineStateDescriptor.fragmentFunction                = fragmentProgram;
    pipelineStateDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
    pipelineStateDescriptor.depthAttachmentPixelFormat      = _depthPixelFormat;
    
    // create a compiled pipeline state object. Shader functions (from the render pipeline descriptor)
    // are compiled when this is created unlessed they are obtained from the device's cache
    NSError *error = nil;
    _pipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];
    if(!_pipelineState) {
        NSLog(@">> ERROR: Couldnt create a pipeline: %@", error);
        
        // assert here if pipeline coudnt be created for any reason
        assert(0);
    }
    
    MTLDepthStencilDescriptor *depthStateDesc = [[MTLDepthStencilDescriptor alloc] init];
    depthStateDesc.depthCompareFunction = MTLCompareFunctionLess;
    depthStateDesc.depthWriteEnabled = YES;
    _depthState = [_device newDepthStencilStateWithDescriptor:depthStateDesc];
}

- (void)updateRotationWithTimeSinceLastDraw:(NSTimeInterval)timeSinceLastDraw
{
    _rotation += timeSinceLastDraw * 50.0f;
}
#endif

@end
