//
//  Vignette.h
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/08/18.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

@import CoreImage;

@interface Vignette : CIFilter

@property (nonatomic, strong) CIImage *inputImage;

@end
