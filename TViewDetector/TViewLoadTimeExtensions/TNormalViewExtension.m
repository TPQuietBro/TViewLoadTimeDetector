//
//  TNormalViewExtension.m
//  TViewLoadTimeDetectDemo
//
//  Created by 唐鹏 on 2018/12/11.
//  Copyright © 2018 唐鹏. All rights reserved.
//

#import "TNormalViewExtension.h"
#import "UIView+ViewInScreen.h"

@implementation TNormalViewExtension
- (void)excuteConditionWithTargetView:(UIView *)targetView completionBlock:(void (^)(id _Nonnull))block{
    [super excuteConditionWithTargetView:targetView completionBlock:block];
    // 通过是否显示在屏幕上判断
    if ([targetView isDisplayedInScreen]) {
        SAFE_BLOCK(block,@"");
    } else {
        if (self.targetView && [self emptyViewIsShownInView:self.targetView]) {
            SAFE_BLOCK(block,@"");
        } else if ([self emptyViewIsShownInView:ExtentionManager.detectedController.view]) {
            SAFE_BLOCK(block,@"");
        }
    }
}

- (NSInteger)type{
    return YYViewLoadTimeReportTypeOtherView;
}

- (BOOL)allowDetecting{
    return YES;
}

- (void)reportData{
    [super reportData];
}
@end
