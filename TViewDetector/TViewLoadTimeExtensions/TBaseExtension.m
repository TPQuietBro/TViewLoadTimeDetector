//
//  TBaseExtension.m
//  TViewLoadTimeDetectDemo
//
//  Created by 唐鹏 on 2018/12/11.
//  Copyright © 2018 唐鹏. All rights reserved.
//

#import "TBaseExtension.h"

#define DEFAULT_CONSUME_LIMIT 5

@implementation TBaseExtension
- (void)excuteConditionWithTargetView:(id)targetView completionBlock:(void (^)(id callBackValue))block{
    self.targetView = targetView;
}

- (NSInteger)type{
    return YYViewLoadTimeReportTypeInit;
}

- (void)reportData{
    if (self.cost <= DEFAULT_CONSUME_LIMIT) {
        NSLog(@"%@ %@ cost %lf to be appeared", _uri,[_targetView class],_cost);
    } else {
        NSLog(@"warning: %@ targetView %@ cost over 5s",_uri,[_targetView class]);
    }
}

- (BOOL)emptyViewIsShownInView:(UIView *)view{
    UIView *emptyView = [self emptyViewInView:view];
    if ([emptyView isDisplayedInScreen]) {
        return YES;
    }
    return NO;
}

- (UIView *)emptyViewInView:(UIView *)view{
    NSString *key = NSStringFromClass([ExtentionManager.detectedController class]);
    for (UIView *subview in view.subviews) {
        NSString *emptyViewType = NSStringFromClass([subview class]);
        if ([[ConfigureReader targetEmptyViewWithControllerKey:key] isEqualToString:emptyViewType]) {
            return subview;
        }
    }
    // 先广度再深度
    for (UIView *subview in view.subviews) {
        [self emptyViewInView:subview];
    }
    return nil;
}

@end
