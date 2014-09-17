/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
 Structure type definitions for plasma uniforms.

*/

#ifndef _METAL_PLASMA_TYPES_H_
#define _METAL_PLASMA_TYPES_H_

#import <simd/simd.h>

#ifdef __cplusplus

namespace AAPL
{
    namespace Plasma
    {
        namespace Uniforms
        {
            struct Vertex
            {
                simd::float4x4  m_ModelView;
                simd::float4x4  m_Projection;
            };
            
            struct Fragment
            {
                float    mnTime;
                float    mnScale;
                uint32_t mnType;
            };
        };
        
        struct Transforms
        {
            float           mnAspect;
            float           mnFOVY;
            float           mnRotation;
            simd::float4x4  m_Projection;
            simd::float4x4  m_View;
            simd::float4x4  m_Model;
            simd::float4x4  m_ModelView;
        };
        
        static const uint32_t kSzVertUniforms = sizeof(Uniforms::Vertex);
        static const uint32_t kSzFragUniforms = sizeof(Uniforms::Fragment);
    } // Plasma
} // AAPL

#endif

#endif
