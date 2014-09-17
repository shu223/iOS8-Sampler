/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information

 */

#import <memory>

#import "AAPLPlasmaParams.h"

class AAPL::Plasma::ParamBlock
{
public:
    ParamBlock(const float& nValue,
               const float& nDelta,
               const float& nMin,
               const float& nMax,
               const float& nSgn)
    {
        mnValue = nValue;
        mnDelta = nDelta;
        mnMin   = nMin;
        mnMax   = nMax;
        mnSgn   = nSgn;
    }
    
    virtual ~ParamBlock()
    {
        mnValue = 0.0f;
        mnDelta = 0.0f;
        mnMin   = 0.0f;
        mnMax   = 0.0f;
        mnSgn   = 0.0f;
    }
    
    ParamBlock(const ParamBlock& rParams)
    {
        mnValue = rParams.mnValue;
        mnDelta = rParams.mnDelta;
        mnMin   = rParams.mnMin;
        mnMax   = rParams.mnMax;
        mnSgn   = rParams.mnSgn;
    }
    
    ParamBlock& operator=(const ParamBlock& rParams)
    {
        if(this != &rParams)
        {
            mnValue = rParams.mnValue;
            mnDelta = rParams.mnDelta;
            mnMin   = rParams.mnMin;
            mnMax   = rParams.mnMax;
            mnSgn   = rParams.mnSgn;
        }
        
        return *this;
    }
    
    ParamBlock& operator=(const float& k)
    {
        mnValue = k;
        mnDelta = k;
        mnMin   = k;
        mnMax   = k;
        mnSgn   = k;
        
        return *this;
    }
    
public:
    float  mnValue;
    float  mnDelta;
    float  mnMin;
    float  mnMax;
    float  mnSgn;
};

static AAPL::Plasma::ParamBlock kTime  = AAPL::Plasma::ParamBlock(0.0f, 0.08f, 0.0f, 12.0f * float(M_PI), 1.0f);
static AAPL::Plasma::ParamBlock kScale = AAPL::Plasma::ParamBlock(1.0f, 0.125f, 1.0f, 32.0f, 1.0f);

static float AAPLPlasmaParamBlockUpdate(AAPL::Plasma::ParamBlock& rParamBlock)
{
    rParamBlock.mnValue += (rParamBlock.mnSgn * rParamBlock.mnDelta);
    
    if( rParamBlock.mnValue >= rParamBlock.mnMax )
    {
        rParamBlock.mnSgn = -1.0f;
    } // if
    else if( rParamBlock.mnValue <= rParamBlock.mnMin )
    {
        rParamBlock.mnSgn = 1.0f;
    } // else if
    
    return rParamBlock.mnValue;
}

AAPL::Plasma::Params::Params()
: m_Time(kTime), m_Scale(kScale)
{
}

AAPL::Plasma::Params::Params(AAPL::Plasma::ParamBlock& rTime,
                             AAPL::Plasma::ParamBlock& rScale)
: m_Time(rTime), m_Scale(rScale)
{
}

AAPL::Plasma::Params::~Params()
{
    m_Time  = 0.0f;
    m_Scale = 0.0f;
}

AAPL::Plasma::Params::Params(const AAPL::Plasma::Params& rParams)
: m_Time(rParams.m_Time), m_Scale(rParams.m_Scale)
{
}

AAPL::Plasma::Params& AAPL::Plasma::Params::operator=(const AAPL::Plasma::Params& rParams)
{
    if(this != &rParams)
    {
        m_Time  = rParams.m_Time;
        m_Scale = rParams.m_Scale;
    }
    
    return *this;
}

AAPL::Vector2 AAPL::Plasma::Params::update()
{
    AAPL::Vector2 v;
    
    v.time  = AAPLPlasmaParamBlockUpdate(m_Time);
    v.scale = AAPLPlasmaParamBlockUpdate(m_Scale);
    
    return v;
}


