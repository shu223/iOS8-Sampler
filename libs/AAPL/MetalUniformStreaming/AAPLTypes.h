/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  Structure type definitions for Metal.
  
 */

#ifndef _METAL_TYPES_H_
#define _METAL_TYPES_H_

#import <Foundation/Foundation.h>

#ifdef __cplusplus

namespace AAPL
{
    union Offset
    {
        NSUInteger v[2];
        
        struct{ NSUInteger x, y; };
    };
    
    typedef union Offset Offset;
    
    union Vector2
    {
        float v[2];
        
        union
        {
            struct{ float x, y; };
            struct{ float re, im; };
            struct{ float time, scale; };
            struct{ float width, height; };
        };
    };
    
    typedef union Vector2 Vector2;
    
    union Vector3
    {
        float v[3];
        
        union
        {
            struct{ float x, y, z; };
            struct{ float r, g, b; };
            struct{ float width, height, depth; };
        };
    };
    
    typedef union Vector3 Vector3;
    
    union Vector4
    {
        float v[4];
        
        union
        {
            struct{ float x, y, z, w; };
            struct{ float r, g, b, a; };
        };
    };
    
    typedef union Vector4 Vector4;
    
    static const uint32_t kSzOffset  = sizeof(Offset);
    static const uint32_t kSzVector2 = sizeof(Vector2);
    static const uint32_t kSzVector3 = sizeof(Vector3);
    static const uint32_t kSzVector4 = sizeof(Vector4);
} // AAPL

#endif

#endif
