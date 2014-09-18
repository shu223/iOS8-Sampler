//
//  MetalBasicViewController.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/09/17.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//
//  Based on Apple's sample code:
//  https://developer.apple.com/library/prerelease/ios/samplecode/MetalBasic3D/


#import "MetalBasicViewController.h"
#import <TargetConditionals.h>
#if !TARGET_IPHONE_SIMULATOR
#import "AAPLView.h"
#import "MetalBasicRenderer.h"
#endif


@interface MetalBasicViewController ()
#if !TARGET_IPHONE_SIMULATOR
{
    BOOL firstDrawOccurred;
    
    CFTimeInterval timeSinceLastDrawPreviousTime;
    NSTimeInterval timeSinceLastDraw;
    
    BOOL gameLoopPaused;
    
    CADisplayLink *_timer;
}
@property (nonatomic, strong) MetalBasicRenderer *renderer;
#endif
@end


@implementation MetalBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];

#if TARGET_IPHONE_SIMULATOR
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.numberOfLines = 0;
    label.text = @"Metal related features CANNOT \nbe available on simulators.";
    [label sizeToFit];
    label.center = self.view.center;
    [self.view addSubview:label];
#else
    self.renderer = [MetalBasicRenderer new];
    AAPLView *renderView = (AAPLView *)self.view;
    renderView.delegate = self.renderer;
    
    // load all renderer assets before starting game loop
    [self.renderer configure:renderView];
#endif
}

#if !TARGET_IPHONE_SIMULATOR
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(didEnterBackground:)
                                                 name: UIApplicationDidEnterBackgroundNotification
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(willEnterForeground:)
                                                 name: UIApplicationWillEnterForegroundNotification
                                               object: nil];
    
    [self dispatchGameLoop];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];

    [self stopGameLoop];

    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: UIApplicationDidEnterBackgroundNotification
                                                  object: nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: UIApplicationWillEnterForegroundNotification
                                                  object: nil];
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

// used to fire off the main game loop
- (void)dispatchGameLoop {
    
    _timer = [[UIScreen mainScreen] displayLinkWithTarget:self
                                                 selector:@selector(gameloop)];
    _timer.frameInterval = 1;
    [_timer addToRunLoop:[NSRunLoop mainRunLoop]
                 forMode:NSDefaultRunLoopMode];
}

// use invalidates the main game loop. when the app is set to terminate
- (void)gameloop {
    
    // tell our delegate to update itself here.
    [self.renderer updateRotationWithTimeSinceLastDraw:timeSinceLastDraw];
    if (!firstDrawOccurred)
    {
        // set up timing data for display since this is the first time through this loop
        timeSinceLastDraw             = 0.0;
        timeSinceLastDrawPreviousTime = CACurrentMediaTime();
        firstDrawOccurred              = YES;
    }
    else
    {
        // figure out the time since we last we drew
        CFTimeInterval currentTime = CACurrentMediaTime();
        
        timeSinceLastDraw = currentTime - timeSinceLastDrawPreviousTime;
        
        // keep track of the time interval between draws
        timeSinceLastDrawPreviousTime = currentTime;
    }
    
    // display (render)
    assert([self.view isKindOfClass:[AAPLView class]]);

    // call the display method directly on the render view (setNeedsDisplay: has been disabled in the renderview by default)
    [(AAPLView *)self.view display];
}

- (void)stopGameLoop {
    
    if (_timer) {
        [_timer invalidate];
    }
}

- (void)setPaused:(BOOL)pause
{
    if (gameLoopPaused == pause)
    {
        return;
    }
    
    if (_timer) {
        
        if (pause == YES) {
            
            gameLoopPaused = pause;
            _timer.paused   = YES;
            
            // ask the view to release textures until its resumed
            [(AAPLView *)self.view releaseTextures];
        }
        else {
            
            gameLoopPaused = pause;
            _timer.paused   = NO;
        }
    }
}

- (BOOL)isPaused {
    
    return gameLoopPaused;
}


// =============================================================================
#pragma mark - Notification Handlers

- (void)didEnterBackground:(NSNotification*)notification {
    
    [self setPaused:YES];
}

- (void)willEnterForeground:(NSNotification*)notification {
    
    [self setPaused:NO];
}
#endif

@end
