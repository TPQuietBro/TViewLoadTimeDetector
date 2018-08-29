//
//  YYViewLoadTimeDetectConfigureReader.m
//  TViewLoadTimeDetectDemo
//
//  Created by 唐鹏 on 2018/8/24.
//  Copyright © 2018年 唐鹏. All rights reserved.
//

#import "YYViewLoadTimeDetectConfigureReader.h"

static NSString *const kTargetSubView = @"TargetSubview";
static NSString *const kTargetSubViewType = @"TargetSubviewType";
@interface YYViewLoadTimeDetectConfigureReader()
@property (nonatomic, strong) NSDictionary *cacheDict;
@end

@implementation YYViewLoadTimeDetectConfigureReader
+ (NSString *)targetViewWithControllerKey:(NSString *)key{
    NSDictionary *items = [self configureRootDict];
    NSString *targetViewStr = items[key][kTargetSubView];
    return targetViewStr;
}

/**
 targetViewType

 @param key controller name
 @return viewType
 */
+ (YYTargetViewControllerSubviewType)targetViewType:(NSString *)key{
    NSDictionary *items = [self configureRootDict];
    BOOL targetViewType = [items[key][kTargetSubViewType] integerValue];
    return targetViewType;
}

+ (NSDictionary *)configureRootDict{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ViewDetectConfigure" ofType:@"plist"];
    NSDictionary *rootDict = [NSDictionary dictionaryWithContentsOfFile:path];
    return rootDict;
}
@end
