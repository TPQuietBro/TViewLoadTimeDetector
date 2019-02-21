//
//  YYViewLoadTimeDetectConfigureReader.h
//  TViewLoadTimeDetectDemo
//
//  Created by 唐鹏 on 2018/8/24.
//  Copyright © 2018年 唐鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

#define ConfigureReader [YYViewLoadTimeDetectConfigureReader sharedInstance]

@interface YYViewLoadTimeDetectConfigureReader : NSObject
+ (instancetype)sharedInstance;
- (NSString *)targetViewWithControllerKey:(NSString *)key;
- (YYViewLoadTimeReportType)targetViewType:(NSString *)key;
- (NSDictionary *)configureRootDict;
- (NSArray *)allExtensions;
/**
 某些控制器数据为空时含有空白页,空白页可能有多种类型
 
 @param key 控制器名称
 @return 包含空白页类型的数组
 */
- (NSString *)targetEmptyViewWithControllerKey:(NSString *)key;
@end
