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
static NSString *const kConfigCache = @"kConfigCache";
static NSString *const kYYViewLoadTimeExtensions = @"YYViewLoadTimeExtension";
static NSString *const kTargetSubViewEmpty = @"TargetEmptyViewType";
@interface YYViewLoadTimeDetectConfigureReader()
@property (nonatomic, strong) NSCache *configCache;
@end

@implementation YYViewLoadTimeDetectConfigureReader

+ (instancetype)sharedInstance{
    static YYViewLoadTimeDetectConfigureReader *singlton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singlton = [[self alloc] init];
    });
    return singlton;
}

- (NSString *)targetViewWithControllerKey:(NSString *)key{
    NSDictionary *items = [self configureRootDict];
    NSString *targetViewStr = items[key][kTargetSubView];
    return targetViewStr;
}

/**
 targetViewType

 @param key controller name
 @return viewType
 */
- (YYViewLoadTimeReportType)targetViewType:(NSString *)key{
    NSDictionary *items = [self configureRootDict];
    YYViewLoadTimeReportType targetViewType = [items[key][kTargetSubViewType] integerValue];
    return targetViewType;
}

- (NSArray *)allExtensions{
    NSArray *extensions = [self configureRootDict][kYYViewLoadTimeExtensions];
    if (extensions.count == 0) {
        return nil;
    }
    return extensions;
}

- (NSString *)targetEmptyViewWithControllerKey:(NSString *)key{
    NSDictionary *items = [self configureRootDict];
    NSString *targetEmptyView = items[key][kTargetSubViewEmpty];
    return targetEmptyView;
}

- (NSDictionary *)configureRootDict{
    if ([self.configCache objectForKey:kConfigCache]) {
        return [self.configCache objectForKey:kConfigCache];
    }
    // plist
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"ViewDetectConfigure" ofType:@"plist"];
//    NSDictionary *rootDict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    // json
    NSDictionary *rootDict = @{
                               @"ViewController":@{
                                       @"TargetSubview" : @"UITableView",
                                       @"TargetSubviewType" : @(0),
                                       @"TargetEmptyViewType":@"NoDataView"
                                       },
                               @"TempViewController":@{
                                       @"TargetSubview" : @"TempView",
                                       @"TargetSubviewType" : @(1),
                                       @"TargetEmptyViewType":@"NoDataView"
                                       },
                               @"TempWebviewController":@{
                                       @"TargetSubview" : @"WKWebView",
                                       @"TargetSubviewType" : @(2),
                                       @"TargetEmptyViewType":@"NoDataView"
                                       },
                               @"NoDataViewController":@{
                                       @"TargetSubview" : @"UITableView",
                                       @"TargetSubviewType" : @(0),
                                       @"TargetEmptyViewType":@"NoDataView"
                                       },
//                               @"NoDataViewController":@{
//                                       @"TargetSubview" : @"DataView",
//                                       @"TargetSubviewType" : @(1),
//                                       @"TargetEmptyViewType":@"NoDataView"
//                                       },
                               @"FatherViewController":@{
                                       @"TargetSubview" : @"SuperView",
                                       @"TargetSubviewType" : @(1),
                                       @"TargetEmptyViewType":@"NoDataView"
                                       },
                               @"YYViewLoadTimeExtension":@[
                                       @"TListViewExtesion",
                                       @"TNormalViewExtension",
                                       @"TWebviewExtension"
                                       ]
                               };
    
    [self.configCache setObject:rootDict forKey:kConfigCache];
    return rootDict;
}

- (NSCache *)configCache{
    if (!_configCache) {
        _configCache = [[NSCache alloc] init];
    }
    return _configCache;
}
@end
