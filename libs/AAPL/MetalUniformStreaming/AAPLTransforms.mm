/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information

 */

#pragma mark -
#pragma mark Private - Headers

#import <cmath>
#import <iostream>

#import "AAPLTransforms.h"

#pragma mark -
#pragma mark Private - Constants

static const float kPi_f      = float(M_PI);
static const float k1Div180_f = 1.0f / 180.0f;
static const float kRadians_f = k1Div180_f * kPi_f;

#pragma mark -
#pragma mark Private - Utilities

float AAPL::Math::radians(const float& degrees)
{
    return kRadians_f * degrees;
} // radians

#pragma mark -
#pragma mark Public - Transformations - Scale

simd::float4x4 AAPL::Math::scale(const float& x,
                                 const float& y,
                                 const float& z)
{
    simd::float4 v = {x, y, z, 1.0f};
    
    return simd::float4x4(v);
} // scale

simd::float4x4 AAPL::Math::scale(const simd::float3& s)
{
    simd::float4 v = {s.x, s.y, s.z, 1.0f};
    
    return simd::float4x4(v);
} // scale

#pragma mark -
#pragma mark Public - Transformations - Translate

simd::float4x4 AAPL::Math::translate(const simd::float3& t)
{
    simd::float4x4 M = matrix_identity_float4x4;
    
    M.columns[3].xyz = t;
    
    return M;
} // translate

simd::float4x4 AAPL::Math::translate(const float& x,
                                     const float& y,
                                     const float& z)
{
    return AAPL::Math::translate((simd::float3){x,y,z});
} // translate

#pragma mark -
#pragma mark Public - Transformations - Rotate

static float AAPLRadiansOverPi(const float& degrees)
{
    return (degrees * k1Div180_f);
} // AAPLRadiansOverPi

simd::float4x4 AAPL::Math::rotate(const float& angle,
                                  const simd::float3& r)
{
    float a = AAPLRadiansOverPi(angle);
    float c = 0.0f;
    float s = 0.0f;
    
    // Computes the sine and cosine of pi times angle (measured in radians)
    // faster and gives exact results for angle = 90, 180, 270, etc.
    __sincospif(a, &s, &c);
    
    float k = 1.0f - c;
    
    simd::float3 u = simd::normalize(r);
    simd::float3 v = s * u;
    simd::float3 w = k * u;
    
    simd::float4 P = 0.0f;
    simd::float4 Q = 0.0f;
    simd::float4 R = 0.0f;
    simd::float4 S = 0.0f;
    
    P.x = w.x * u.x + c;
    P.y = w.x * u.y + v.z;
    P.z = w.x * u.z - v.y;
    
    Q.x = w.x * u.y - v.z;
    Q.y = w.y * u.y + c;
    Q.z = w.y * u.z + v.x;
    
    R.x = w.x * u.z + v.y;
    R.y = w.y * u.z - v.x;
    R.z = w.z * u.z + c;
    
    S.w = 1.0f;
    
    return simd::float4x4(P, Q, R, S);
} // rotate

simd::float4x4 AAPL::Math::rotate(const float& angle,
                                  const float& x,
                                  const float& y,
                                  const float& z)
{
    simd::float3 r = {x, y, z};
    
    return AAPL::Math::rotate(angle, r);
} // rotate

#pragma mark -
#pragma mark Public - Transformations - Perspective

simd::float4x4 AAPL::Math::perspective(const float& width,
                                       const float& height,
                                       const float& near,
                                       const float& far)
{
    float zNear = 2.0f * near;
    float zFar  = far / (far - near);
    
    simd::float4 P = 0.0f;
    simd::float4 Q = 0.0f;
    simd::float4 R = 0.0f;
    simd::float4 S = 0.0f;
    
    P.x =  zNear / width;
    Q.y =  zNear / height;
    R.z =  zFar;
    R.w =  1.0f;
    S.z = -near * zFar;
    
    return simd::float4x4(P, Q, R, S);
} // perspective

simd::float4x4 AAPL::Math::perspective_fov(const float& fovy,
                                           const float& aspect,
                                           const float& near,
                                           const float& far)
{
    float angle  = AAPL::Math::radians(0.5f * fovy);
    float yScale = 1.0f/ std::tan(angle);
    float xScale = yScale / aspect;
    float zScale = far / (far - near);
    
    simd::float4 P = 0.0f;
    simd::float4 Q = 0.0f;
    simd::float4 R = 0.0f;
    simd::float4 S = 0.0f;
    
    P.x =  xScale;
    Q.y =  yScale;
    R.z =  zScale;
    R.w =  1.0f;
    S.z = -near * zScale;
    
    return simd::float4x4(P, Q, R, S);
} // perspective_fov

simd::float4x4 AAPL::Math::perspective_fov(const float& fovy,
                                           const float& width,
                                           const float& height,
                                           const float& near,
                                           const float& far)
{
    float aspect = width / height;
    
    return AAPL::Math::perspective_fov(fovy, aspect, near, far);
} // perspective_fov

#pragma mark -
#pragma mark Public - Transformations - LookAt

simd::float4x4 AAPL::Math::lookAt(const simd::float3& eye,
                                  const simd::float3& center,
                                  const simd::float3& up)
{
    simd::float3 E = -eye;
    simd::float3 N = simd::normalize(center + E);
    simd::float3 U = simd::normalize(simd::cross(up, N));
    simd::float3 V = simd::cross(N, U);
    
    simd::float4 P = 0.0f;
    simd::float4 Q = 0.0f;
    simd::float4 R = 0.0f;
    simd::float4 S = 0.0f;
    
    P.x = U.x;
    P.y = V.x;
    P.z = N.x;
    
    Q.x = U.y;
    Q.y = V.y;
    Q.z = N.y;
    
    R.x = U.z;
    R.y = V.z;
    R.z = N.z;
    
    S.x = simd::dot(U, E);
    S.y = simd::dot(V, E);
    S.z = simd::dot(N, E);
    S.w = 1.0f;
    
    return simd::float4x4(P, Q, R, S);
} // lookAt

simd::float4x4 AAPL::Math::lookAt(const float * const pEye,
                                  const float * const pCenter,
                                  const float * const pUp)
{
    simd::float3 eye    = {pEye[0], pEye[1], pEye[2]};
    simd::float3 center = {pCenter[0], pCenter[1], pCenter[2]};
    simd::float3 up     = {pUp[0], pUp[1], pUp[2]};
    
    return AAPL::Math::lookAt(eye, center, up);
} // lookAt

#pragma mark -
#pragma mark Public - Transformations - Orthographic

simd::float4x4 AAPL::Math::ortho2d(const float& left,
                                   const float& right,
                                   const float& bottom,
                                   const float& top,
                                   const float& near,
                                   const float& far)
{
    float sLength = 1.0f / (right - left);
    float sHeight = 1.0f / (top   - bottom);
    float sDepth  = 1.0f / (far   - near);
    
    simd::float4 P = 0.0f;
    simd::float4 Q = 0.0f;
    simd::float4 R = 0.0f;
    simd::float4 S = 0.0f;
    
    P.x =  2.0f * sLength;
    Q.y =  2.0f * sHeight;
    R.z =  sDepth;
    S.z = -near  * sDepth;
    S.w =  1.0f;
    
    return simd::float4x4(P, Q, R, S);
} // ortho2d

simd::float4x4 AAPL::Math::ortho2d(const simd::float3& origin,
                                   const simd::float3& size)
{
    return AAPL::Math::ortho2d(origin.x, origin.y, origin.z, size.x, size.y, size.z);
} // ortho2d

#pragma mark -
#pragma mark Public - Transformations - Off-Center Orthographic

simd::float4x4 AAPL::Math::ortho2d_oc(const float& left,
                                      const float& right,
                                      const float& bottom,
                                      const float& top,
                                      const float& near,
                                      const float& far)
{
    float sLength = 1.0f / (right - left);
    float sHeight = 1.0f / (top   - bottom);
    float sDepth  = 1.0f / (far   - near);
    
    simd::float4 P = 0.0f;
    simd::float4 Q = 0.0f;
    simd::float4 R = 0.0f;
    simd::float4 S = 0.0f;
    
    P.x =  2.0f * sLength;
    Q.y =  2.0f * sHeight;
    R.z =  sDepth;
    S.x = -sLength * (left + right);
    S.y = -sHeight * (top + bottom);
    S.z = -sDepth  * near;
    S.w =  1.0f;
    
    return simd::float4x4(P, Q, R, S);
} // ortho2d_oc

simd::float4x4 AAPL::Math::ortho2d_oc(const simd::float3& origin,
                                      const simd::float3& size)
{
    return AAPL::Math::ortho2d_oc(origin.x, origin.y, origin.z, size.x, size.y, size.z);
} // ortho2d_oc

#pragma mark -
#pragma mark Public - Transformations - frustum

simd::float4x4 AAPL::Math::frustum(const float& fovH,
                                   const float& fovV,
                                   const float& near,
                                   const float& far)
{
    float width  = 1.0f / std::tan(AAPL::Math::radians(0.5f * fovH));
    float height = 1.0f / std::tan(AAPL::Math::radians(0.5f * fovV));
    float sDepth = far / ( far - near );
    
    simd::float4 P = 0.0f;
    simd::float4 Q = 0.0f;
    simd::float4 R = 0.0f;
    simd::float4 S = 0.0f;
    
    P.x =  width;
    Q.y =  height;
    R.z =  sDepth;
    R.w =  1.0f;
    S.z = -sDepth * near;
    
    return simd::float4x4(P, Q, R, S);
} // frustum

simd::float4x4 AAPL::Math::frustum(const float& left,
                                   const float& right,
                                   const float& bottom,
                                   const float& top,
                                   const float& near,
                                   const float& far)
{
    float width  = right - left;
    float height = top   - bottom;
    float depth  = far   - near;
    float sDepth = far / depth;
    
    simd::float4 P = 0.0f;
    simd::float4 Q = 0.0f;
    simd::float4 R = 0.0f;
    simd::float4 S = 0.0f;
    
    P.x =  width;
    Q.y =  height;
    R.z =  sDepth;
    R.w =  1.0f;
    S.z = -sDepth * near;
    
    return simd::float4x4(P, Q, R, S);
} // frustum

simd::float4x4 AAPL::Math::frustum_oc(const float& left,
                                      const float& right,
                                      const float& bottom,
                                      const float& top,
                                      const float& near,
                                      const float& far)
{
    float sWidth  = 1.0f / (right - left);
    float sHeight = 1.0f / (top   - bottom);
    float sDepth  = far  / (far   - near);
    float dNear   = 2.0f * near;
    
    simd::float4 P = 0.0f;
    simd::float4 Q = 0.0f;
    simd::float4 R = 0.0f;
    simd::float4 S = 0.0f;
    
    P.x =  dNear * sWidth;
    Q.y =  dNear * sHeight;
    R.x = -sWidth  * (right + left);
    R.y = -sHeight * (top   + bottom);
    R.z =  sDepth;
    R.w =  1.0f;
    S.z = -sDepth * near;
    
    return simd::float4x4(P, Q, R, S);
} // frustum_oc
