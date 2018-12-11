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
@end
