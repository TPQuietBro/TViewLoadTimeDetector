//
//  TBaseExtension.h
//  TViewLoadTimeDetectDemo
//
//  Created by 唐鹏 on 2018/12/11.
//  Copyright © 2018 唐鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TViewLoadTimeProtocol.h"
#import "Defines.h"
#import "UIView+YYViewInScreen.h"
#import "YYViewLoadTimeDetectConfigureReader.h"
#import "TExtensionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface TBaseExtension : NSObject <TViewLoadTimeProtocol>
// 当前检测的控制器
@property (nonatomic, strong) UIViewController *detectedController;
@property (nonatomic, assign) NSTimeInterval cost;
@property (nonatomic, strong) NSString *uri;
@property (nonatomic, strong) UIView *targetView;
- (void)reportData NS_REQUIRES_SUPER;
- (BOOL)emptyViewIsShownInView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
