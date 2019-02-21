//
//  TempWebviewController.m
//  TViewLoadTimeDetectDemo
//
//  Created by 唐鹏 on 2019/2/21.
//  Copyright © 2019 唐鹏. All rights reserved.
//

#import "TempWebviewController.h"
#import <WebKit/WebKit.h>

@interface TempWebviewController ()<WKNavigationDelegate>

@property (nonatomic, strong) NSDate *viewDidLoadDate;
@property (nonatomic, strong) NSDate *webStartDate;
@end

@implementation TempWebviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.viewDidLoadDate = [NSDate date];
    
    WKWebView *webview = [[WKWebView alloc] init];
    webview.frame = self.view.bounds;
    webview.navigationDelegate = self;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [self.view addSubview:webview];
    
    [webview loadRequest:request];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    self.webStartDate = [NSDate date];
    NSLog(@"start load");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSTimeInterval cost1 = [[NSDate date] timeIntervalSinceDate:self.viewDidLoadDate];
    NSTimeInterval cost2 = [[NSDate date] timeIntervalSinceDate:self.webStartDate];
    NSLog(@"end loading cost all_time : %lf start_end:%lf",cost1,cost2);
}

@end
