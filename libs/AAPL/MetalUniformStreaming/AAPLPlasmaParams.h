/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  Plasma structures, constants, and utility functions.
  
 */

#ifndef _METAL_PLASMA_UTILITIES_H_
#define _METAL_PLASMA_UTILITIES_H_

#import <simd/simd.h>

#import "AAPLTypes.h"

#ifdef __cplusplus

namespace AAPL
{
    namespace Plasma
    {
        class ParamBlock;
        
        class Params
        {
        public:
            Params();
            
            Params(ParamBlock& rTime,
                   ParamBlock& rScale);
            
            virtual ~Params();
            
            Params(const Params& rParams);
            
            Params& operator=(const Params& rParams);
            
            Vector2 update();
            
        private:
            ParamBlock&  m_Time;
            ParamBlock&  m_Scale;
        };
    } // Plasma
} // AAPL

#endif

#endif
