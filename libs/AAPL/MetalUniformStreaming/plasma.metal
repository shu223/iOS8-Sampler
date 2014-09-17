/*
 <samplecode>
 <abstract>
 Plasma shader class.
 </abstract>
 </samplecode>
 */

#include <metal_stdlib>
#include <metal_graphics>
#include <metal_matrix>
#include <metal_geometric>
#include <metal_math>
#include <metal_texture>

using namespace metal;

#define M_PI  3.14159265358979323846264338327950288

constant float kPi   = float(M_PI);
constant float k2Pi3 = 2.0 * kPi/3.0;
constant float k4Pi3 = 4.0 * kPi/3.0;

struct VertexOutput
{
    float4 m_Position [[position]];
    float2 m_TexCoord [[user(texturecoord)]];
};

struct FragmentInput
{
    float4 m_Position [[position]];
    float2 m_TexCoord [[user(texturecoord)]];
};

struct VertexUniforms
{
    float4x4  m_ModelView;
    float4x4  m_Projection;
};

struct FragmentUniforms
{
    float  mnTime;
    float  mnScale;
    uint   mnType;
};

// vertex shader function
vertex VertexOutput plasmaVertex(constant packed_float3    *pPositions  [[ buffer(0) ]],
                                 constant packed_float3    *pNormals    [[ buffer(1) ]],
                                 constant packed_float2    *pTexCoords  [[ buffer(2) ]],
                                 constant VertexUniforms  *pUniforms    [[ buffer(3) ]],
                                 uint                       nVID        [[ vertex_id ]])
{
    VertexOutput outVertex;
    
    float3  inPosition = float3(pPositions[nVID]);
    float4  inVertex   = float4(inPosition, 1.0);
    float2  inTexCoord = float2(pTexCoords[nVID]);
    float4  position   = pUniforms->m_ModelView * inVertex;
    
    outVertex.m_Position = pUniforms->m_Projection * position;
    outVertex.m_TexCoord = inTexCoord;
    
    return outVertex;
}

// fragment shader function
fragment half4 plasmaFragment(FragmentInput               inFrag    [[ stage_in  ]],
                              constant FragmentUniforms  *pUniforms [[ buffer(0) ]])
{
    uint type = pUniforms->mnType;
    
    float t = pUniforms->mnTime;
    float s = pUniforms->mnScale;
    
    float2 f = float2(inFrag.m_TexCoord - 0.5) * s;
    float2 p = float2(sin(t/3.0), cos(t/2.0));
    
    float z = sin(f.x + t);
    
    z += sin(0.5 * (f.y + t));
    z += sin(0.5 * (f.x + f.y + t));
    
    f += (0.5 * s * p);
    
    float y = dot(f, f) + 1.0;
    
    z += sin(sqrt(y) + t);
    z *= 0.5;
    
    float w = kPi * z;
    
    float3 color = 0.0;
    
    switch(type)
    {
        case 0:
            color.r = sin(w);
            color.g = cos(w);
            color.b = 0.0;
            
            break;
            
        case 1:
            color.r = 1.0;
            color.g = cos(w);
            color.b = sin(w);
            
            break;
            
        case 2:
            color.r = sin(w);
            color.g = sin(w + k2Pi3);
            color.b = sin(w + k4Pi3);
            
            break;
            
        default:
            float c = sin(5.0 * w);
            
            color.r = c;
            color.g = c;
            color.b = c;
            
            break;
    }
    
    color = 0.5 * (color + 1.0);
    
    return half4(color.r, color.g, color.b, 1.0);
};
