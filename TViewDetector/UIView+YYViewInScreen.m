//
//  UIView+YYViewInScreen.m
//  ChannelProject
//
//  Created by 唐鹏 on 2018/5/26.
//  Copyright © 2018年 YY. All rights reserved.
//

#import "UIView+YYViewInScreen.h"

@implementation UIView (YYViewInScreen)
- (BOOL)isDisplayedInScreen
{
    if (self == nil) {
        return NO;
    }
    
    UIWindow *win= [UIApplication sharedApplication].keyWindow;
    CGRect rect = [self convertRect:self.frame toView:win];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return NO;
    }
    
    if (self.hidden) {
        return NO;
    }
    
    if (self.superview == nil) {
        return NO;
    }
    
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return  NO;
    }
    
    if (self.alpha <= 0.01) {
        return NO;
    }

    return YES;
}
@end
