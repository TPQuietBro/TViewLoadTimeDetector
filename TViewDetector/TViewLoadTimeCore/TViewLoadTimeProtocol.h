//
//  TViewLoadTimeProtocol.h
//  TViewLoadTimeDetectDemo
//
//  Created by 唐鹏 on 2018/12/11.
//  Copyright © 2018 唐鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TViewLoadTimeProtocol <NSObject>
- (void)excuteConditionWithTargetView:(id)targetView completionBlock:(void(^)(id callBackValue))block;
- (NSInteger)type;
@optional
- (BOOL)allowDetecting;
@end

NS_ASSUME_NONNULL_END
