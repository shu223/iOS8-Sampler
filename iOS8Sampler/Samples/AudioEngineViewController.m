//
//  AudioEngineViewController.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/08/25.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "AudioEngineViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "TTMAudioUnitEffectHelper.h"


//NSString * const kAudioFilename = @"bgm8.wav";
NSString * const kAudioFilename = @"bgm_2.aif";
//NSString * const kAudioFilename = @"bgm_3.aif";
//NSString * const kAudioFilename = @"bgm_5.aif";
//NSString * const kAudioFilename = @"mh2_03.wav";
//NSString * const kAudioFilename = @"mh2_09.wav";


@interface AudioEngineViewController ()
<UIPickerViewDataSource, UIPickerViewDelegate>
{
    AVAudioUnitDistortionPreset currentPreset;
}
@property (nonatomic, strong) AVAudioEngine *engine;
@property (nonatomic, strong) AVAudioPlayerNode *playerNode;
@property (nonatomic, strong) AVAudioFile *audioFile;
@property (nonatomic, strong) AVAudioUnitEQ *unitEq;
@property (nonatomic, strong) AVAudioUnitDistortion *unitDistortion;
@property (nonatomic, strong) AVAudioUnitDelay *unitDelay;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) IBOutlet UISwitch *playerSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *eqSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *distortionSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *delaySwitch;
@property (nonatomic, weak) IBOutlet UILabel *distortionLabel;
@property (nonatomic, weak) IBOutlet UILabel *delayTimeLabel;
@property (nonatomic, weak) IBOutlet UISlider *delayTimeSlider;
@property (nonatomic, weak) IBOutlet UILabel *feedbackLabel;
@property (nonatomic, weak) IBOutlet UISlider *feedbackSlider;
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;
@end


@implementation AudioEngineViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    
    // setup for picker view
    self.items = [TTMAudioUnitEffectHelper factoryPresetShortNames];
    self.pickerView.hidden = YES;
    
    
    self.engine = [[AVAudioEngine alloc] init];

    NSString *path = [[NSBundle mainBundle] pathForResource:kAudioFilename ofType:nil];
    self.audioFile = [[AVAudioFile alloc] initForReading:[NSURL fileURLWithPath:path]
                                                   error:nil];
    
    [self setupPlayer];
    [self setupEQ];
    [self setupDistortion];
    [self setupDelay];

    // Connect Nodes
    // [Player] -> [EQ] -> [Distortion] -> [Delay] -> [Output]
    AVAudioMixerNode *mixerNode = [self.engine mainMixerNode];
    [self.engine connect:self.playerNode to:self.unitEq format:self.audioFile.processingFormat];
    [self.engine connect:self.unitEq to:self.unitDistortion format:self.audioFile.processingFormat];
    [self.engine connect:self.unitDistortion to:self.unitDelay format:self.audioFile.processingFormat];
    [self.engine connect:self.unitDelay to:mixerNode format:self.audioFile.processingFormat];
    
    // Start the engine.
    NSError *error;
    [self.engine startAndReturnError:&error];
    if (error) {
        NSLog(@"error:%@", error);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    [self playerSwitchChanged:nil];
    [self eqSwitchChanged:nil];
    [self delaySwitchChanged:nil];
    [self delayTimeSliderChanged:nil];
    [self feedbackSliderChanged:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
 
    // stop playing
    [self.playerNode stop];

    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


// =============================================================================
#pragma mark - Private

- (void)setupPlayer {

    self.playerNode = [[AVAudioPlayerNode alloc] init];
    [self.engine attachNode:self.playerNode];
}

- (void)setupEQ {

    self.unitEq = [[AVAudioUnitEQ alloc] initWithNumberOfBands:2];
    
    AVAudioUnitEQFilterParameters *filterParameters;
    filterParameters = self.unitEq.bands[0];
    filterParameters.filterType = AVAudioUnitEQFilterTypeHighPass;
    filterParameters.frequency = 80;
    
    filterParameters = self.unitEq.bands[1];
    filterParameters.filterType = AVAudioUnitEQFilterTypeParametric;
    filterParameters.frequency = 500;
    filterParameters.bandwidth = 2.0;
    filterParameters.gain = 4.0;

    [self.engine attachNode:self.unitEq];
}

- (void)setupDistortion {
    
    self.unitDistortion = [[AVAudioUnitDistortion alloc] init];

    [self.engine attachNode:self.unitDistortion];

    // default
    [self pickerView:self.pickerView didSelectRow:18 inComponent:0];
}

- (void)setupDelay {
    
    self.unitDelay = [[AVAudioUnitDelay alloc] init];
    [self.engine attachNode:self.unitDelay];
}

- (void)setupReverve {

    AVAudioEnvironmentNode *environmentNode = [[AVAudioEnvironmentNode alloc] init];
    AVAudioEnvironmentReverbParameters *reverbParameters = environmentNode.reverbParameters;
    reverbParameters.enable = YES;
    [reverbParameters loadFactoryReverbPreset:AVAudioUnitReverbPresetLargeHall];
    self.playerNode.reverbBlend = 0.2;
}

- (void)play {

    [self.playerNode scheduleFile:self.audioFile
                           atTime:nil
                completionHandler:^{
                    
                    // repeat
                    [self play];
                }];
    
    [self.playerNode play];
}

- (void)updateDistortionLabel:(NSString *)presetName {
    
    self.distortionLabel.text = [NSString stringWithFormat:@"PRESET: %@", presetName];
}



// =============================================================================
#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.items.count;
}


// =============================================================================
#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.items[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    // update factory preset
    NSString *title = self.items[row];
    NSInteger presetValue = [TTMAudioUnitEffectHelper valueForFactoryPresetShortName:title];
    if (presetValue >= 0) {
        currentPreset = presetValue;
        [self.unitDistortion loadFactoryPreset:currentPreset];
        [self updateDistortionLabel:title];
    }
}


// =============================================================================
#pragma mark - Touch Handlers

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (!self.pickerView.hidden) {
        self.pickerView.hidden = YES;
    }
}


// =============================================================================
#pragma mark - IBAction

- (IBAction)playerSwitchChanged:(id)sender {
    
    if (self.playerSwitch.isOn) {

        [self play];
    }
    else {
        [self.playerNode stop];
    }
}

- (IBAction)eqSwitchChanged:(UISwitch *)sender {
    
    self.unitEq.bypass = !self.eqSwitch.isOn;
}

- (IBAction)distortionSwitchChanged:(id)sender {
    
    self.unitDistortion.bypass = !self.distortionSwitch.isOn;
}

- (IBAction)distortionPresetChangeBtnTapped:(id)sender {
    
    self.pickerView.hidden = NO;
}

- (IBAction)delaySwitchChanged:(UISwitch *)sender {

    self.unitDelay.bypass = !self.delaySwitch.isOn;
}

- (IBAction)delayTimeSliderChanged:(UISlider *)sender {
    
    self.delayTimeLabel.text = [NSString stringWithFormat:@"%1.3f", self.delayTimeSlider.value];
    self.unitDelay.delayTime = self.delayTimeSlider.value;
}

- (IBAction)feedbackSliderChanged:(id)sender {
    
    self.feedbackLabel.text = [NSString stringWithFormat:@"%4.0f", self.feedbackSlider.value];
    self.unitDelay.feedback = self.feedbackSlider.value;
}

@end
