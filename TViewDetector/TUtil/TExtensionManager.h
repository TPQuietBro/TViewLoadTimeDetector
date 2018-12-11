//
//  TExtensionManager.h
//  TViewLoadTimeDetectDemo
//
//  Created by 唐鹏 on 2018/12/11.
//  Copyright © 2018 唐鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TViewLoadTimeProtocol.h"

#define ExtentionManager [TExtensionManager sharedInstance]

NS_ASSUME_NONNULL_BEGIN

@interface TExtensionManager : NSObject
+ (instancetype)sharedInstance;
// 当前检测的控制器
@property (nonatomic, weak) UIViewController *detectedController;
// 添加所有的扩展
- (void)addDetectingExtensions:(NSArray<NSString *> *)extensions;
// 如果有添加阻断条件,就调用
- (BOOL)allowDetectingByType:(NSInteger)type;
// 每个扩展各自的实现方式
- (void)performWithTargetView:(id)targetView targetType:(NSInteger)type completeHandler:(void(^)(id value))handler;
// 接收参数上报
- (void)recieveReportDataByCost:(NSTimeInterval)cost uri:(NSString *)uri userData:(NSDictionary *)userData;
@end

NS_ASSUME_NONNULL_END
