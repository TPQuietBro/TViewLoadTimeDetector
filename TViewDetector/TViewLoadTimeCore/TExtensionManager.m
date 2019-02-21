//
//  TExtensionManager.m
//  TViewLoadTimeDetectDemo
//
//  Created by 唐鹏 on 2018/12/11.
//  Copyright © 2018 唐鹏. All rights reserved.
//

#import "TExtensionManager.h"
#import "TBaseExtension.h"

#define isDumplicatedExtension(obj) [self isDumplicatedObjectWithClassName:obj]

@interface TExtensionManager()
@property (nonatomic, strong) NSMutableDictionary<NSNumber *,id<TViewLoadTimeProtocol>> *extensions;
@property (nonatomic, assign) YYViewLoadTimeReportType type;
@end
@implementation TExtensionManager

+ (instancetype)sharedInstance{
    static TExtensionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)addDetectingExtensions:(NSArray<NSString *> *)extensions{
    [extensions enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (isDumplicatedExtension(obj)) {
            *stop = YES;
        }
        
        Class class = NSClassFromString(obj);
        id extensionObject = [[class alloc] init];
        if ([extensionObject conformsToProtocol:@protocol(TViewLoadTimeProtocol)]) {
            [self addDetectingExtension:extensionObject];
        }
    }];
}

- (void)addDetectingExtension:(TBaseExtension<TViewLoadTimeProtocol> *)extension{
    if (extension && [extension respondsToSelector:@selector(type)]) {
        [self.extensions setObject:extension forKey:@([extension type])];
    }
}

- (void)performWithTargetView:(id)targetView targetType:(NSInteger)type completeHandler:(nonnull void (^)(id value))handler{
    if (type < YYViewLoadTimeReportTypeInit || type > YYViewLoadTimeReportTypeWebView) {
        return;
    }
    if (self.extensions.count <= 0) {
        return;
    }
    self.type = type;
    id<TViewLoadTimeProtocol> extension = [self.extensions objectForKey:@(type)];
    [extension excuteConditionWithTargetView:targetView completionBlock:^(id  _Nonnull callBackValue) {
        SAFE_BLOCK(handler,callBackValue);
    }];
}

- (BOOL)allowDetectingByType:(NSInteger)type{
    id<TViewLoadTimeProtocol> extension = [self.extensions objectForKey:@(type)];
    if ([extension respondsToSelector:@selector(allowDetecting)]) {
        return [extension allowDetecting];
    }
    return YES;
}

- (void)recieveReportDataByCost:(NSTimeInterval)cost uri:(NSString *)uri userData:(NSDictionary *)userData{
    TBaseExtension *extension = [self.extensions objectForKey:@(self.type)];
    extension.cost = cost;
    extension.uri = uri;
    [extension reportData];
}

#pragma mark - private

- (BOOL)isDumplicatedObjectWithClassName:(NSString *)className{
    if (self.extensions.count == 0) return NO;
    __block BOOL isDumplicated = NO;
    [self.extensions enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, id<TViewLoadTimeProtocol>  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *extensionClassName = NSStringFromClass([obj class]);
        isDumplicated = [extensionClassName isEqualToString:className];
        *stop = isDumplicated;
    }];
    return isDumplicated;
}

#pragma mark - getter
- (NSMutableDictionary<NSNumber *,id<TViewLoadTimeProtocol>> *)extensions{
    if (!_extensions) {
        _extensions = [[NSMutableDictionary alloc] init];
    }
    return _extensions;
}
@end
