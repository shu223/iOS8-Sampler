//
//  AccordionFoldTransitionViewController.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/08/18.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "AccordionFoldTransitionViewController.h"
@import GLKit;


@interface AccordionFoldTransitionViewController ()
<GLKViewDelegate>
{
    NSTimeInterval  base;
    CGRect destRect;
}
@property (nonatomic, strong) GLKView *glkView;
@property (nonatomic, strong) CIImage *image1;
@property (nonatomic, strong) CIImage *image2;
@property (nonatomic, strong) CIImage *maskImage;
@property (nonatomic, strong) CIVector *extent;
@property (nonatomic, strong) CIFilter *transition;
@property (nonatomic, strong) CIContext *myContext;
@property (nonatomic, assign) NSTimer *timer;
@end


@implementation AccordionFoldTransitionViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    UIImage *uiImage1    = [UIImage imageNamed:@"stage_1"];
    UIImage *uiImage2    = [UIImage imageNamed:@"stage_6"];
    
    self.image1    = [CIImage imageWithCGImage:uiImage1.CGImage];
    self.image2    = [CIImage imageWithCGImage:uiImage2.CGImage];
    
    self.extent = [CIVector vectorWithX:0
                                      Y:0
                                      Z:uiImage1.size.width
                                      W:uiImage2.size.height];

    base = [NSDate timeIntervalSinceReferenceDate];

    self.glkView = [[GLKView alloc] initWithFrame:self.view.bounds];
    self.glkView.delegate = self;
    self.glkView.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [self.view addSubview:self.glkView];
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    destRect = CGRectMake(0, 0, self.glkView.frame.size.width * scale, self.glkView.frame.size.height * scale);
    
    self.myContext = [CIContext contextWithEAGLContext:self.glkView.context];

    
    self.transition = [CIFilter filterWithName: @"CIAccordionFoldTransition"];
    
//    NSLog(@"attributes:%@", [self.transition attributes]);
    /*
     CIAccordionFoldTransition's attributes:
     
    CIAttributeFilterCategories =     (
        CICategoryTransition,
        CICategoryVideo,
        CICategoryStillImage,
        CICategoryBuiltIn
    );
    CIAttributeFilterDisplayName = "Accordion Fold Transition";
    CIAttributeFilterName = CIAccordionFoldTransition;
    inputBottomHeight =     {
        CIAttributeClass = NSNumber;
        CIAttributeDefault = 0;
        CIAttributeMin = 0;
        CIAttributeType = CIAttributeTypeDistance;
    };
    inputFoldShadowAmount =     {
        CIAttributeClass = NSNumber;
        CIAttributeDefault = "0.1";
        CIAttributeMax = 1;
        CIAttributeMin = 0;
        CIAttributeSliderMax = 1;
        CIAttributeSliderMin = 0;
        CIAttributeType = CIAttributeTypeScalar;
    };
    inputImage =     {
        CIAttributeClass = CIImage;
        CIAttributeType = CIAttributeTypeImage;
    };
    inputNumberOfFolds =     {
        CIAttributeClass = NSNumber;
        CIAttributeDefault = 3;
        CIAttributeMax = 50;
        CIAttributeMin = 1;
        CIAttributeSliderMax = 10;
        CIAttributeSliderMin = 1;
        CIAttributeType = CIAttributeTypeScalar;
    };
    inputTargetImage =     {
        CIAttributeClass = CIImage;
        CIAttributeType = CIAttributeTypeImage;
    };
    inputTime =     {
        CIAttributeClass = NSNumber;
        CIAttributeDefault = 0;
        CIAttributeIdentity = 0;
        CIAttributeMin = 0;
        CIAttributeSliderMax = 1;
        CIAttributeSliderMin = 0;
        CIAttributeType = CIAttributeTypeTime;
    };
     */
    [self.transition setValue:@3 forKey:@"inputNumberOfFolds"];
    [self.transition setValue:@0.5 forKey:@"inputFoldShadowAmount"];
    [self.transition setValue:@50 forKey:@"inputBottomHeight"];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 30.0
                                                  target:self
                                                selector:@selector(onTimer:)
                                                userInfo:nil
                                                 repeats:YES];
    [self.timer fire];
}

- (void)viewWillLayoutSubviews {

    self.glkView.frame = self.view.bounds;
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];

    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// =============================================================================
#pragma mark - Private

- (CIImage *)imageForTransitionAtTime:(float)time
{
    // toggle images
    if (fmodf(time, 2.0) < 1.0f)
    {
        [self.transition setValue:self.image1 forKey:@"inputImage"];
        [self.transition setValue:self.image2 forKey:@"inputTargetImage"];
    }
    else
    {
        [self.transition setValue:self.image2 forKey:@"inputImage"];
        [self.transition setValue:self.image1 forKey:@"inputTargetImage"];
    }

    // calc input time
    CGFloat transitionTime = 0.5 * (1 - cos(fmodf(time, 1.0f) * M_PI));
    [self.transition setValue:@(transitionTime) forKey:@"inputTime"];

    // apply filter
    CIImage *transitionImage = [self.transition valueForKey:@"outputImage"];
    
    return transitionImage;
}




// =============================================================================
#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        float t = 0.4 * ([NSDate timeIntervalSinceReferenceDate] - base);
        
        CIImage *image = [self imageForTransitionAtTime:t];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.myContext drawImage:image
                               inRect:destRect
                             fromRect:image.extent];
        });
    });
}


// =============================================================================
#pragma mark - Timer Handler

- (void)onTimer:(NSTimer *)timer {
    
    [self.glkView setNeedsDisplay];
}

@end
