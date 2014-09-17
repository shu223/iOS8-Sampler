/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information

 */

#import <string>

#import "AAPLCube.h"

static const uint32_t kCntVertices = 24;
static const uint32_t kSzVertices  = kCntVertices  * AAPL::kSzVector3;

static const uint32_t kCntNormals = kCntVertices;
static const uint32_t kSzNormals  = kCntNormals * AAPL::kSzVector3;

static const uint32_t kCntTexCoords = kCntVertices;
static const uint32_t kSzTexCoords  = kCntTexCoords * AAPL::kSzVector2;

@implementation AAPLCube
{
@private
    id <MTLBuffer>  m_VertexBuffer;
    id <MTLBuffer>  m_NormalBuffer;
    id <MTLBuffer>  m_TexCoordBuffer;
    id <MTLBuffer>  m_IndexBuffer;
    
    float          _length;
    AAPL::Vector3  _size;
    
    NSUInteger  mnIndexCount;
    NSUInteger  _vertexIndex;
    NSUInteger  _normalIndex;
    NSUInteger  _texCoordIndex;
}

- (void) dealloc
{
    // Private
    m_VertexBuffer   = nil;
    m_NormalBuffer   = nil;
    m_TexCoordBuffer = nil;
    m_IndexBuffer    = nil;
} // dealloc

- (id <MTLBuffer>) _newVertexBuffer:(AAPL::Vector3)size
                             device:(id <MTLDevice>)device
{
    _size = size;
    
    const AAPL::Vector3 kVertices[kCntVertices] =
    {
        {-size.width, -size.height, -size.depth},   //0
        {-size.width, -size.height, -size.depth},   //0
        {-size.width, -size.height, -size.depth},   //0
        
        {-size.width, -size.height, size.depth},    //3
        {-size.width, -size.height, size.depth},    //3
        {-size.width, -size.height, size.depth},    //3
        
        {size.width, -size.height, -size.depth},    //6
        {size.width, -size.height, -size.depth},    //6
        {size.width, -size.height, -size.depth},    //6
        
        {size.width, -size.height, size.depth},     //9
        {size.width, -size.height, size.depth},     //9
        {size.width, -size.height, size.depth},     //9
        
        {size.width, size.height, -size.depth},     //12
        {size.width, size.height, -size.depth},     //12
        
        {size.width, size.height, size.depth},      //14
        {size.width, size.height, size.depth},      //14
        
        {-size.width, size.height, -size.depth},    //16
        {-size.width, size.height, -size.depth},    //16
        
        {-size.width, size.height, size.depth},     //18
        {-size.width, size.height, size.depth},     //18
        
        { size.width, size.height, -size.depth},
        { size.width, size.height,  size.depth},
        {-size.width, size.height, -size.depth},
        {-size.width, size.height,  size.depth}
    };
    
    // Set the default vertex buffer index (binding point)
    _vertexIndex = 0;
    
    // setup the vertex buffers
    id <MTLBuffer> vertexBuffer = [device newBufferWithBytes:kVertices
                                                      length:kSzVertices
                                                     options:MTLResourceOptionCPUCacheModeDefault];
    
    return vertexBuffer;
} // _newVertexBuffer

- (id <MTLBuffer>) _newNormalBuffer:(id <MTLDevice>)device
{
    const AAPL::Vector3 kNormals[kCntNormals] =
    {
        {  0.0,  0.0, -1.0 },
        { -1.0,  0.0,  0.0 },
        {  0.0, -1.0,  0.0 },
        
        {  0.0,  0.0, 1.0 },
        { -1.0,  0.0, 0.0 },
        {  0.0, -1.0, 0.0 },
        
        { 0.0,  0.0, -1.0 },
        { 1.0,  0.0,  0.0 },
        { 0.0, -1.0,  0.0 },
        
        { 0.0,  0.0,  1.0 },
        { 1.0,  0.0,  0.0 },
        { 0.0, -1.0,  0.0 },
        
        { 1.0, 0.0,  0.0 },
        { 0.0, 1.0,  0.0 },
        
        { 1.0, 0.0,  0.0 },
        { 0.0, 1.0,  0.0 },
        
        { -1.0, 0.0,  0.0 },
        {  0.0, 1.0,  0.0 },
        
        { -1.0, 0.0,  0.0 },
        {  0.0, 1.0,  0.0 },
        
        { 0.0, 0.0, -1.0 },
        { 0.0, 0.0,  1.0 },
        { 0.0, 0.0, -1.0 },
        { 0.0, 0.0,  1.0 }
    };
    
    // Set the default normal buffer index (binding point)
    _normalIndex = 1;
    
    id <MTLBuffer> normalBuffer = [device newBufferWithBytes:kNormals
                                                      length:kSzNormals
                                                     options:MTLResourceOptionCPUCacheModeDefault];
    
    return normalBuffer;
} // _newNormalBuffer

- (id <MTLBuffer>) _newTexCoordBuffer:(id <MTLDevice>)device
{
    const AAPL::Vector2 kTexCoords[kCntTexCoords] =
    {
        {0.0, 1.0},
        {1.0, 0.0},
        {0.0, 0.0},
        
        {0.0, 0.0},
        {1.0, 1.0},
        {0.0, 1.0},
        
        {1.0, 1.0},
        {0.0, 0.0},
        {1.0, 0.0},
        
        {1.0, 0.0},
        {0.0, 1.0},
        {1.0, 1.0},
        
        {1.0, 0.0},
        {0.0, 0.0},
        
        {1.0, 1.0},
        {0.0, 1.0},
        
        {0.0, 0.0},
        {1.0, 0.0},
        
        {0.0, 1.0},
        {1.0, 1.0},
        
        {1.0, 0.0},
        {1.0, 1.0},
        {0.0, 0.0},
        {0.0, 1.0}
    };
    
    // Set the default texture coordinate buffer index (binding point)
    _texCoordIndex = 2;
    
    id <MTLBuffer> texCoordBuffer = [device newBufferWithBytes:kTexCoords
                                                        length:kSzTexCoords
                                                       options:MTLResourceOptionCPUCacheModeDefault];
    
    return texCoordBuffer;
} // _newTexCoordBuffer

- (id <MTLBuffer>) _newIndexBuffer:(id <MTLDevice>)device
{
    const uint32_t kCntIndicies = 36;
    const uint32_t kSzIndices   = kCntIndicies  * sizeof(uint32_t);
    
    const uint32_t kIndices[kCntIndicies] =
    {
        11,  5,  2,
         8, 11,  2,
        14, 10,  7,
        12, 14,  7,
        19, 15, 13,
        17, 19, 13,
         4, 18, 16,
         1,  4, 16,
        21, 23,  3,
         3,  9, 21,
         6,  0, 22,
        20,  6, 22
    };
    
    mnIndexCount = kCntIndicies;
    
    id <MTLBuffer> indexBuffer = [device newBufferWithBytes:kIndices
                                                     length:kSzIndices
                                                    options:MTLResourceOptionCPUCacheModeDefault];
    
    return indexBuffer;
} // _newIndexBuffer

- (instancetype) initWithDevice:(id <MTLDevice>)device
                           size:(AAPL::Vector3)size
{
    self = [super init];
    
    if(self)
    {
        if(!device)
        {
            NSLog(@">> ERROR: Invalid device!");
            
            return nil;
        } // if
        
        // setup the vertex buffers
        m_VertexBuffer = [self _newVertexBuffer:size
                                         device:device];
        
        if(!m_VertexBuffer)
        {
            NSLog(@">> ERROR: Failed creating a vertex buffer!");
            
            return nil;
        } // if
        
        m_NormalBuffer = [self _newNormalBuffer:device];
        
        if(!m_NormalBuffer)
        {
            NSLog(@">> ERROR: Failed creating a normals buffer!");
            
            return nil;
        } // if
        
        m_TexCoordBuffer = [self _newTexCoordBuffer:device];
        
        if(!m_TexCoordBuffer)
        {
            NSLog(@">> ERROR: Failed creating a texture coordinate buffer!");
            
            return nil;
        } // if
        
        m_IndexBuffer = [self _newIndexBuffer:device];
        
        if(!m_IndexBuffer)
        {
            NSLog(@">> ERROR: Failed creating an index buffer!");
            
            return nil;
        } // if
    } // if
    
    return self;
} // initWithDevice

- (instancetype) initWithDevice:(id <MTLDevice>)device
                         length:(float)length
{
    AAPL::Vector3 size = {length, length, length};
    
    return [[AAPLCube alloc] initWithDevice:device
                                       size:size];
} // initWithDevice

- (void) setNormalIndex:(NSUInteger)normalIndex
{
    _normalIndex = normalIndex;
} // setNormalIndex

- (void) setTexCoordIndex:(NSUInteger)texCoordIndex
{
    _texCoordIndex = texCoordIndex;
} // setTexCoordIndex

- (void) setVertexIndex:(NSUInteger)vertexIndex
{
    _vertexIndex = vertexIndex;
} // setVertexIndex

- (void) setSize:(AAPL::Vector3)size
{
    BOOL bIsChnaged =       (size.width  != _size.width)
                        ||  (size.height != _size.height)
                        ||  (size.depth  != _size.depth);
    
    if(bIsChnaged)
    {
        // Get the base address of the constant buffer
        AAPL::Vector3 *pVertexPointer = (AAPL::Vector3 *)[m_VertexBuffer contents];
        
        if(pVertexPointer)
        {
            _size = size;
            
            const AAPL::Vector3 kVertices[kCntVertices] =
            {
                {-size.width, -size.height, -size.depth},   //0
                {-size.width, -size.height, -size.depth},   //0
                {-size.width, -size.height, -size.depth},   //0
                
                {-size.width, -size.height, size.depth},    //3
                {-size.width, -size.height, size.depth},    //3
                {-size.width, -size.height, size.depth},    //3
                
                {size.width, -size.height, -size.depth},    //6
                {size.width, -size.height, -size.depth},    //6
                {size.width, -size.height, -size.depth},    //6
                
                {size.width, -size.height, size.depth},     //9
                {size.width, -size.height, size.depth},     //9
                {size.width, -size.height, size.depth},     //9
                
                {size.width, size.height, -size.depth},     //12
                {size.width, size.height, -size.depth},     //12
                
                {size.width, size.height, size.depth},      //14
                {size.width, size.height, size.depth},      //14
                
                {-size.width, size.height, -size.depth},    //16
                {-size.width, size.height, -size.depth},    //16
                
                {-size.width, size.height, size.depth},     //18
                {-size.width, size.height, size.depth},     //18
                
                { size.width, size.height, -size.depth},
                { size.width, size.height,  size.depth},
                {-size.width, size.height, -size.depth},
                {-size.width, size.height,  size.depth}
            };
            
            std::memcpy(pVertexPointer, kVertices, kSzVertices);
        } // if
    } // if
} // setSize

- (void) setLength:(float)length
{
    _length = length;
    
    AAPL::Vector3 size = {_length, _length, _length};
    
    [self setSize:size];
} // setLength

- (void) encode:(id <MTLRenderCommandEncoder>)renderEncoder
{
    [renderEncoder setVertexBuffer:m_VertexBuffer
                            offset:0
                           atIndex:_vertexIndex ];
    
    [renderEncoder setVertexBuffer:m_NormalBuffer
                            offset:0
                           atIndex:_normalIndex ];
    
    [renderEncoder setVertexBuffer:m_TexCoordBuffer
                            offset:0
                           atIndex:_texCoordIndex ];
} // encode

- (void) draw:(id <MTLRenderCommandEncoder>)renderEncoder
{
    // Tell the render context we want to draw our first set of primitives
    [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                              indexCount:mnIndexCount
                               indexType:MTLIndexTypeUInt32
                             indexBuffer:m_IndexBuffer
                       indexBufferOffset:0];
} // draw

@end
