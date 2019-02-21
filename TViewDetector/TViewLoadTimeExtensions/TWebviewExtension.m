//
//  TWebviewExtension.m
//  TViewLoadTimeDetectDemo
//
//  Created by 唐鹏 on 2018/12/11.
//  Copyright © 2018 唐鹏. All rights reserved.
//

#import "TWebviewExtension.h"
#import <WebKit/WebKit.h>

@implementation TWebviewExtension
- (void)excuteConditionWithTargetView:(id)targetView completionBlock:(void (^)(id _Nonnull))block{
    [super excuteConditionWithTargetView:targetView completionBlock:block];
    if ([targetView isKindOfClass:[WKWebView class]]) {
        WKWebView *webview = targetView;
        if (webview.URL.absoluteString.length != 0 && !webview.isLoading) {
            SAFE_BLOCK(block,targetView);
        }
    } else if ([targetView isKindOfClass:[UIWebView class]]){
        UIWebView *webview = targetView;
        if (webview.request.URL.absoluteString.length != 0 && !webview.isLoading) {
            SAFE_BLOCK(block,targetView);
        }
    } else {
        if ([self emptyViewIsShownInView:self.targetView]) {
            SAFE_BLOCK(block,@"");
        }
    }
}

- (NSInteger)type{
    return YYViewLoadTimeReportTypeWebView;
}

- (BOOL)allowDetecting{
    return YES;
}

- (void)reportData{
    [super reportData];
}
@end
