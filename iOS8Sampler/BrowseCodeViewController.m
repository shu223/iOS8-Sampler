//
//  BrowseCodeViewController.m
//  iOS7Sampler
//
//  Created by shuichi on 2/10/14.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "BrowseCodeViewController.h"
#import "SVProgressHUD.h"


@interface BrowseCodeViewController ()
<UIWebViewDelegate>
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@end


@implementation BrowseCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView.delegate = self;
    
    [self startLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


// =============================================================================
#pragma mark - Private

- (void)startLoad {
    
    if (!self.urlString) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
    
    [SVProgressHUD showWithStatus:@"Loading..."
                         maskType:SVProgressHUDMaskTypeGradient];
}


// =============================================================================
#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    [SVProgressHUD dismiss];
}

@end
