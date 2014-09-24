//
//  WebKitViewController.m
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2014/08/18.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "WebKitViewController.h"
#import "SVProgressHUD.h"
@import WebKit;


@interface WebKitViewController ()
<WKNavigationDelegate>
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, strong) WKWebView *webView;
@end


@implementation WebKitViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    NSURL *url = [[NSURL alloc] initWithString:@"https://twitter.com/shu223"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self update:nil];
}

- (void)viewWillLayoutSubviews {
    self.webView.frame = self.view.bounds;
}

- (void)update:(CADisplayLink *)link {
    
    if ([self.webView isLoading]) {
        [SVProgressHUD showProgress:self.webView.estimatedProgress status:@"LOADING..."];
    }
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];

    [self.link invalidate];
    self.link = nil;

    if ([self.webView isLoading]) {
        [self.webView stopLoading];
    }
    
    [SVProgressHUD dismiss];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    self.webView.navigationDelegate = nil;
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
#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [SVProgressHUD showSuccessWithStatus:@"DONE!"];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"navigation failed:%@, %@", navigation, error);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"navigation failed:%@, %@", navigation, error);
}

@end
