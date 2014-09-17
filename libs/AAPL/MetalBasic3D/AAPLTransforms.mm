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
static const float kRadians   = k1Div180_f * kPi_f;

#pragma mark -
#pragma mark Private - Utilities

float AAPL::radians(const float& degrees)
{
    return kRadians * degrees;
} // radians

#pragma mark -
#pragma mark Public - Transformations - Scale

simd::float4x4 AAPL::scale(const float& x,
                           const float& y,
                           const float& z)
{
    simd::float4 v = {x, y, z, 1.0f};
    
    return simd::float4x4(v);
} // scale

simd::float4x4 AAPL::scale(const simd::float3& s)
{
    simd::float4 v = {s.x, s.y, s.z, 1.0f};
    
    return simd::float4x4(v);
} // scale

#pragma mark -
#pragma mark Public - Transformations - Translate

simd::float4x4 AAPL::translate(const simd::float3& t)
{
    simd::float4x4 M = matrix_identity_float4x4;
    
    M.columns[3].xyz = t;
    
    return M;
} // translate

simd::float4x4 AAPL::translate(const float& x,
                               const float& y,
                               const float& z)
{
    return AAPL::translate((simd::float3){x,y,z});
} // translate

#pragma mark -
#pragma mark Public - Transformations - Rotate

static float AAPLRadiansOverPi(const float& degrees)
{
    return (degrees * k1Div180_f);
} // AAPLRadiansOverPi

simd::float4x4 AAPL::rotate(const float& angle,
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
    
    simd::float4 P;
    simd::float4 Q;
    simd::float4 R;
    simd::float4 S;
    
    P.x = w.x * u.x + c;
    P.y = w.x * u.y + v.z;
    P.z = w.x * u.z - v.y;
    P.w = 0.0f;
    
    Q.x = w.x * u.y - v.z;
    Q.y = w.y * u.y + c;
    Q.z = w.y * u.z + v.x;
    Q.w = 0.0f;
    
    R.x = w.x * u.z + v.y;
    R.y = w.y * u.z - v.x;
    R.z = w.z * u.z + c;
    R.w = 0.0f;
    
    S.x = 0.0f;
    S.y = 0.0f;
    S.z = 0.0f;
    S.w = 1.0f;
    
    return simd::float4x4(P, Q, R, S);
} // rotate

simd::float4x4 AAPL::rotate(const float& angle,
                            const float& x,
                            const float& y,
                            const float& z)
{
    simd::float3 r = {x, y, z};
    
    return AAPL::rotate(angle, r);
} // rotate

#pragma mark -
#pragma mark Public - Transformations - Perspective

simd::float4x4 AAPL::perspective(const float& width,
                                 const float& height,
                                 const float& near,
                                 const float& far)
{
    float zNear = 2.0f * near;
    float zFar  = far / (far - near);
    
    simd::float4 P;
    simd::float4 Q;
    simd::float4 R;
    simd::float4 S;
    
    P.x = zNear / width;
    P.y = 0.0f;
    P.z = 0.0f;
    P.w = 0.0f;
    
    Q.x = 0.0f;
    Q.y = zNear / height;
    Q.z = 0.0f;
    Q.w = 0.0f;
    
    R.x = 0.0f;
    R.y = 0.0f;
    R.z = zFar;
    R.w = 1.0f;
    
    S.x =  0.0f;
    S.y =  0.0f;
    S.z = -near * zFar;
    S.w =  0.0f;
    
    return simd::float4x4(P, Q, R, S);
} // perspective

simd::float4x4 AAPL::perspective_fov(const float& fovy,
                                     const float& aspect,
                                     const float& near,
                                     const float& far)
{
    float angle  = AAPL::radians(0.5f * fovy);
    float yScale = 1.0f/ std::tan(angle);
    float xScale = yScale / aspect;
    float zScale = far / (far - near);
    
    simd::float4 P;
    simd::float4 Q;
    simd::float4 R;
    simd::float4 S;
    
    P.x = xScale;
    P.y = 0.0f;
    P.z = 0.0f;
    P.w = 0.0f;
    
    Q.x = 0.0f;
    Q.y = yScale;
    Q.z = 0.0f;
    Q.w = 0.0f;
    
    R.x = 0.0f;
    R.y = 0.0f;
    R.z = zScale;
    R.w = 1.0f;
    
    S.x =  0.0f;
    S.y =  0.0f;
    S.z = -near * zScale;
    S.w =  0.0f;
    
    return simd::float4x4(P, Q, R, S);
} // perspective_fov

simd::float4x4 AAPL::perspective_fov(const float& fovy,
                                     const float& width,
                                     const float& height,
                                     const float& near,
                                     const float& far)
{
    float aspect = width / height;
    
    return AAPL::perspective_fov(fovy, aspect, near, far);
} // perspective_fov

#pragma mark -
#pragma mark Public - Transformations - LookAt

simd::float4x4 AAPL::lookAt(const simd::float3& eye,
                            const simd::float3& center,
                            const simd::float3& up)
{
    simd::float3 zAxis = simd::normalize(center - eye);
    simd::float3 xAxis = simd::normalize(simd::cross(up, zAxis));
    simd::float3 yAxis = simd::cross(zAxis, xAxis);
    
    simd::float4 P;
    simd::float4 Q;
    simd::float4 R;
    simd::float4 S;
    
    P.x = xAxis.x;
    P.y = yAxis.x;
    P.z = zAxis.x;
    P.w = 0.0f;
    
    Q.x = xAxis.y;
    Q.y = yAxis.y;
    Q.z = zAxis.y;
    Q.w = 0.0f;
    
    R.x = xAxis.z;
    R.y = yAxis.z;
    R.z = zAxis.z;
    R.w = 0.0f;
    
    S.x = -simd::dot(xAxis, eye);
    S.y = -simd::dot(yAxis, eye);
    S.z = -simd::dot(zAxis, eye);
    S.w =  1.0f;
    
    return simd::float4x4(P, Q, R, S);
} // lookAt

simd::float4x4 AAPL::lookAt(const float * const pEye,
                            const float * const pCenter,
                            const float * const pUp)
{
    simd::float3 eye    = {pEye[0], pEye[1], pEye[2]};
    simd::float3 center = {pCenter[0], pCenter[1], pCenter[2]};
    simd::float3 up     = {pUp[0], pUp[1], pUp[2]};
    
    return AAPL::lookAt(eye, center, up);
} // lookAt

#pragma mark -
#pragma mark Public - Transformations - Orthographic

simd::float4x4 AAPL::ortho2d(const float& left,
                             const float& right,
                             const float& bottom,
                             const float& top,
                             const float& near,
                             const float& far)
{
    float sLength = 1.0f / (right - left);
    float sHeight = 1.0f / (top   - bottom);
    float sDepth  = 1.0f / (far   - near);
    
    simd::float4 P;
    simd::float4 Q;
    simd::float4 R;
    simd::float4 S;
    
    P.x = 2.0f * sLength;
    P.y = 0.0f;
    P.z = 0.0f;
    P.w = 0.0f;
    
    Q.x = 0.0f;
    Q.y = 2.0f * sHeight;
    Q.z = 0.0f;
    Q.w = 0.0f;
    
    R.x = 0.0f;
    R.y = 0.0f;
    R.z = sDepth;
    R.w = 0.0f;
    
    S.x =  0.0f;
    S.y =  0.0f;
    S.z = -near  * sDepth;
    S.w =  1.0f;
    
    return simd::float4x4(P, Q, R, S);
} // ortho2d

simd::float4x4 AAPL::ortho2d(const simd::float3& origin,
                             const simd::float3& size)
{
    return AAPL::ortho2d(origin.x, origin.y, origin.z, size.x, size.y, size.z);
} // ortho2d

#pragma mark -
#pragma mark Public - Transformations - Off-Center Orthographic

simd::float4x4 AAPL::ortho2d_oc(const float& left,
                                const float& right,
                                const float& bottom,
                                const float& top,
                                const float& near,
                                const float& far)
{
    float sLength = 1.0f / (right - left);
    float sHeight = 1.0f / (top   - bottom);
    float sDepth  = 1.0f / (far   - near);
    
    simd::float4 P;
    simd::float4 Q;
    simd::float4 R;
    simd::float4 S;
    
    P.x = 2.0f * sLength;
    P.y = 0.0f;
    P.z = 0.0f;
    P.w = 0.0f;
    
    Q.x = 0.0f;
    Q.y = 2.0f * sHeight;
    Q.z = 0.0f;
    Q.w = 0.0f;
    
    R.x = 0.0f;
    R.y = 0.0f;
    R.z = sDepth;
    R.w = 0.0f;
    
    S.x = -sLength * (left + right);
    S.y = -sHeight * (top + bottom);
    S.z = -sDepth  * near;
    S.w =  1.0f;
    
    return simd::float4x4(P, Q, R, S);
} // ortho2d_oc

simd::float4x4 AAPL::ortho2d_oc(const simd::float3& origin,
                                const simd::float3& size)
{
    return AAPL::ortho2d_oc(origin.x, origin.y, origin.z, size.x, size.y, size.z);
} // ortho2d_oc

#pragma mark -
#pragma mark Public - Transformations - frustum

simd::float4x4 AAPL::frustum(const float& fovH,
                             const float& fovV,
                             const float& near,
                             const float& far)
{
    float width  = 1.0f / std::tan(AAPL::radians(0.5f * fovH));
    float height = 1.0f / std::tan(AAPL::radians(0.5f * fovV));
    float sDepth = far / ( far - near );
    
    simd::float4 P;
    simd::float4 Q;
    simd::float4 R;
    simd::float4 S;
    
    P.x = width;
    P.y = 0.0f;
    P.z = 0.0f;
    P.w = 0.0f;
    
    Q.x = 0.0f;
    Q.y = height;
    Q.z = 0.0f;
    Q.w = 0.0f;
    
    R.x = 0.0f;
    R.y = 0.0f;
    R.z = sDepth;
    R.w = 1.0f;
    
    S.x =  0.0f;
    S.y =  0.0f;
    S.z = -sDepth * near;
    S.w =  0.0f;
    
    return simd::float4x4(P, Q, R, S);
} // frustum

simd::float4x4 AAPL::frustum(const float& left,
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
    
    simd::float4 P;
    simd::float4 Q;
    simd::float4 R;
    simd::float4 S;
    
    P.x = width;
    P.y = 0.0f;
    P.z = 0.0f;
    P.w = 0.0f;
    
    Q.x = 0.0f;
    Q.y = height;
    Q.z = 0.0f;
    Q.w = 0.0f;
    
    R.x = 0.0f;
    R.y = 0.0f;
    R.z = sDepth;
    R.w = 1.0f;
    
    S.x =  0.0f;
    S.y =  0.0f;
    S.z = -sDepth * near;
    S.w =  0.0f;
    
    return simd::float4x4(P, Q, R, S);
} // frustum

simd::float4x4 AAPL::frustum_oc(const float& left,
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
    
    simd::float4 P;
    simd::float4 Q;
    simd::float4 R;
    simd::float4 S;
    
    P.x = dNear * sWidth;
    P.y = 0.0f;
    P.z = 0.0f;
    P.w = 0.0f;
    
    Q.x = 0.0f;
    Q.y = dNear * sHeight;
    Q.z = 0.0f;
    Q.w = 0.0f;
    
    R.x = -sWidth  * (right + left);
    R.y = -sHeight * (top   + bottom);
    R.z =  sDepth;
    R.w =  1.0f;
    
    S.x =  0.0f;
    S.y =  0.0f;
    S.z = -sDepth * near;
    S.w =  0.0f;
    
    return simd::float4x4(P, Q, R, S);
} // frustum_oc
