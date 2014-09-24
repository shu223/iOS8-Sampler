//
//  MasterViewController.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/08/18.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "MasterViewController.h"
#import "BrowseCodeViewController.h"


#define kItemKeyTitle       @"title"
#define kItemKeyDescription @"description"
#define kItemKeyClassPrefix @"prefix"


@interface MasterViewController ()
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSString *currentClassName;
@end


@implementation MasterViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];

    self.items = @[
                   // Audio Effects
                   @{kItemKeyTitle: @"Audio Effects",
                     kItemKeyDescription: @"Distortion and Delay effect for audio using AVAudioEngine.",
                     kItemKeyClassPrefix: @"AudioEngine",
                     },
                   
                   // New Image Filters
                   @{kItemKeyTitle: @"New Image Filters",
                     kItemKeyDescription: @"New filters of CIFilter such as CIGrassDistortion, CIDivideBlendMode, ...",
                     kItemKeyClassPrefix: @"ImageFilters",
                     },

                   // Custom Filters
                   @{kItemKeyTitle: @"CustomFilters",
                     kItemKeyDescription: @"Custom CIFilter examples using CIKernel.",
                     kItemKeyClassPrefix: @"CustomFilters",
                     },

                   // Metal Basic
                   @{kItemKeyTitle: @"Metal Basic",
                     kItemKeyDescription: @"Render a set of cubes using Metal. Based on Apple's \"MetalBasic3D\" sample.",
                     kItemKeyClassPrefix: @"MetalBasic",
                     },
                   
                   // Metal Uniform Stream
                   @{kItemKeyTitle: @"Metal Uniform Stream",
                     kItemKeyDescription: @"Demo using a data buffer to set uniforms for the vertex and fragment shaders.",
                     kItemKeyClassPrefix: @"MetalUniform",
                     },
                   
                   // SceneKit
                   @{kItemKeyTitle: @"SceneKit",
                     kItemKeyDescription: @"Render a 2D image on 3D scene using SceneKit framework.",
                     kItemKeyClassPrefix: @"SceneKit",
                     },
                   
                   // HealthKit
                   @{kItemKeyTitle: @"HealthKit",
                     kItemKeyDescription: @"Fetch all types of data which are available in HealthKit. Need to use a provisioning profile for which HealthKit is enabled.",
                     kItemKeyClassPrefix: @"HealthKit",
                     },
                   
                   // HomeKit (Coming soon!)
//                   @{kItemKeyTitle: @"HomeKit",
//                     kItemKeyDescription: @"HomeKit.",
//                     kItemKeyClassPrefix: @"HomeKit",
//                     },
                   
                   // TouchID
                   @{kItemKeyTitle: @"Touch ID",
                     kItemKeyDescription: @"Invoke Touch ID verification using LocalAuthentication framework.",
                     kItemKeyClassPrefix: @"TouchID",
                     },
                   
                   // Visual Effects
                   @{kItemKeyTitle: @"Visual Effects",
                     kItemKeyDescription: @"Example for UIBlurEffect and UIVibrancyEffect.",
                     kItemKeyClassPrefix: @"VisualEffects",
                     },
                   
                   // Ruby Annotation
                   @{kItemKeyTitle: @"Ruby Annotation",
                     kItemKeyDescription: @"Display the pronunciation of characters using CTRubyAnnotationRef.",
                     kItemKeyClassPrefix: @"RubyAnnotation",
                     },

                   // WebKit
                   @{kItemKeyTitle: @"WebKit",
                     kItemKeyDescription: @"Browsing example using WKWebView.",
                     kItemKeyClassPrefix: @"WebKit",
                     },

                   // UIAlertController
                   @{kItemKeyTitle: @"UIAlertController",
                     kItemKeyDescription: @"Show Alert or ActionSheet using UIAlertController.",
                     kItemKeyClassPrefix: @"Alert",
                     },

                   // User Notification
                   @{kItemKeyTitle: @"User Notification",
                     kItemKeyDescription: @"Schedule a local notification which has custom actions using UIUserNotificationSettings.",
                     kItemKeyClassPrefix: @"UserNotification",
                     },

                   // Altimeter
                   @{kItemKeyTitle: @"Altimeter",
                     kItemKeyDescription: @"Get relative altitude using CMAltimeter. It works only on devices which have M8 motion co-processor.",
                     kItemKeyClassPrefix: @"Altimeter",
                     },

                   // Pedometer
                   @{kItemKeyTitle: @"Pedometer",
                     kItemKeyDescription: @"Counting steps demo using CMPedometer. It works only on devices which have M7 or M8 motion co-processor.",
                     kItemKeyClassPrefix: @"Pedometer",
                     },

                   // AVKit
                   @{kItemKeyTitle: @"AVKit",
                     kItemKeyDescription: @"Media playback demo using AVKit framework.",
                     kItemKeyClassPrefix: @"AVKit",
                     },

                   // Histogram
                   @{kItemKeyTitle: @"Histogram",
                     kItemKeyDescription: @"Generate a histogram from an image using the filters CIAreaHistogram and CIHistogramDisplayFilter.",
                     kItemKeyClassPrefix: @"Histogram",
                     },
                   
                   // Code Generator
                   @{kItemKeyTitle: @"Code Generator",
                     kItemKeyDescription: @"Generate Aztec Code and 128 Barcord.",
                     kItemKeyClassPrefix: @"CodeGenerator",
                     },

                   // New Fonts
                   @{kItemKeyTitle: @"New Fonts",
                     kItemKeyDescription: @"Gallery of new fonts.",
                     kItemKeyClassPrefix: @"Fonts",
                     },

                   // Popover
                   @{kItemKeyTitle: @"Popover",
                     kItemKeyDescription: @"Example of UIPopoverPresentationController.",
                     kItemKeyClassPrefix: @"Popover",
                     },

                   // Accordion Fold Transition
                   @{kItemKeyTitle: @"Accordion Fold Transition",
                     kItemKeyDescription: @"Transitions from one image to another by folding like accordion. However it doesn't work correctly...PULL REQUESTS welcome!!",
                     kItemKeyClassPrefix: @"AccordionFoldTransition",
                     },
                   ];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // Needed after custome transition
    self.navigationController.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Segues
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([[segue identifier] isEqualToString:@"showDetail"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        NSDate *object = self.objects[indexPath.row];
//        [[segue destinationViewController] setDetailItem:object];
//    }
//}



// =============================================================================
#pragma mark - Private

- (Class)swiftClassFromString:(NSString *)className {
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    NSString *classStringName = [NSString stringWithFormat:@"_TtC%lu%@%lu%@",
                                 (unsigned long)appName.length, appName, (unsigned long)className.length, className];
    return NSClassFromString(classStringName);
}


// =============================================================================
#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *info = self.items[indexPath.row];
    cell.textLabel.text = info[kItemKeyTitle];
    cell.detailTextLabel.text = info[kItemKeyDescription];
    
    return cell;
}


// =============================================================================
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *item = self.items[indexPath.row];
    NSString *className = [item[kItemKeyClassPrefix] stringByAppendingString:@"ViewController"];
    
    Class aClass = NSClassFromString(className);
    if (!aClass) {
        aClass = [self swiftClassFromString:className];
    }

    if (aClass) {
        id instance = [[aClass alloc] init];
        
        if ([instance isKindOfClass:[UIViewController class]]) {
            
            self.currentClassName = className;
            
            // CODE button
            UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"CODE"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(codeButtonTapped:)];
            [(UIViewController *)instance navigationItem].rightBarButtonItem = barBtnItem;
            
            [(UIViewController *)instance setTitle:item[kItemKeyTitle]];
            [self.navigationController pushViewController:(UIViewController *)instance
                                                 animated:YES];
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


// =============================================================================
#pragma mark - Actions

- (void)codeButtonTapped:(id)sender {
    
    NSString *urlStr = [NSString stringWithFormat:@"https://github.com/shu223/iOS8-Sampler/blob/master/iOS8Sampler/Samples/%@.m",
                        self.currentClassName];
    NSLog(@"url:%@", urlStr);
    
    BrowseCodeViewController *codeCtr = [[BrowseCodeViewController alloc] init];
    
    [codeCtr setTitle:self.currentClassName];
    [codeCtr setUrlString:urlStr];
    
    [self.navigationController pushViewController:codeCtr
                                         animated:YES];
}

@end
