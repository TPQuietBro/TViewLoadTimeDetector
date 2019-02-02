//
//  UIViewController+YYViewLoadTime.m
//  KVODemo
//
//  Created by 唐鹏 on 2018/8/21.
//  Copyright © 2018年 唐鹏. All rights reserved.
//

#import "UIViewController+YYViewLoadTime.h"
#import "YYViewLoadTimeDetectConfigureReader.h"
#import "UIView+YYViewInScreen.h"
#import "TExtensionManager.h"

@implementation NSObject (Swizzling)

+ (void)swizzleSEL:(SEL)originalSEL withSEL:(SEL)swizzledSEL
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSEL);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSEL,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSEL,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
@end


static NSDate *_date = nil;
static CADisplayLink *_timer = nil;
static UIViewController *_preViewController = nil;
YYViewLoadTimeReportType _targetType = -1;

@implementation UIViewController (Util)

- (void)preInit{
    UIViewController *selfInstance = self;
    _preViewController = selfInstance;
}

// 找到需要检测的子view,递归实现
- (UIView *)targetView{
    NSString *key = NSStringFromClass([self class]);
    NSString *targetViewType = [ConfigureReader targetViewWithControllerKey:key];
    NSArray *subviews = self.view.subviews;
    
    return [self subviewInSubviews:subviews targetViewType:targetViewType];;
}
// 递归获取子view
- (UIView *)subviewInSubviews:(NSArray *)subviews targetViewType:(NSString *)targetViewType{
    // 判断self.view的类型是因为可能重写loadview或者直接将self.view强制赋值
    if ([self.view isKindOfClass:NSClassFromString(targetViewType)]) {
        return self.view;
    }
    for (UIView *subView in subviews) {
        if ([subView isKindOfClass:NSClassFromString(targetViewType)]) {
            return subView;
        } else {
            while (subView.subviews) {
                return [self subviewInSubviews:subView.subviews targetViewType:targetViewType];
            }
        }
    }
    return nil;
}

// 是否是需要检测的控制器
- (BOOL)isTargetVc{
    NSArray *allKeys = [self targetControllerKeys];
    NSString *key = NSStringFromClass([self class]);
    if (![allKeys containsObject:key]) {
        NSLog(@"%@ is not targetVc",[self class]);
        return NO;
    }
    return YES;
}

// 所有需要检测的控制器名称
- (NSArray *)targetControllerKeys{
    NSDictionary *configDict = [ConfigureReader configureRootDict];
#ifdef debug
    NSAssert(configDict, @"configDict is nil");
#endif
    return configDict.allKeys;
}

- (void)addExtensions{
    if ([_preViewController isEqual:self]) {
        return;
    }
    UIViewController *selfInstance = self;
    ExtentionManager.detectedController = selfInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [ExtentionManager addDetectingExtensions:[ConfigureReader allExtensions]];
    });
}

// 销毁定时器
- (void)fireTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _date = nil;
    _targetType = YYViewLoadTimeReportTypeInit;
}

@end

@implementation UIViewController (YYViewLoadTime)

+ (void)load{
    [self swizzleSEL:@selector(viewDidLoad) withSEL:@selector(my_viewDidLoad)];
}

- (void)my_viewDidLoad{
    // 非要监听的控制器不需要添加定时器
    if (![self isTargetVc] || [_preViewController isEqual:self]) {
        [self my_viewDidLoad];
        return;
    }
    [self fireTimer];
    
    [self addExtensions];
    
    [self preInit];
    
    NSDate *date = [NSDate date];
    _date = date;
    [self my_viewDidLoad];
    
    CADisplayLink *timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(detecting:)];
    [timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    _timer = timer;
    
    NSLog(@"%@ start timer",[self class]);
}

// 通过检测两种类型的view来体现加载时间
- (void)detecting:(CADisplayLink *)timer{
    
    NSString *key = NSStringFromClass([self class]);
    // 如果检测到消耗时间大于5s就提个醒,5s可以是其他值
    NSTimeInterval cost = [[NSDate date] timeIntervalSinceDate:_date];
    
    NSDictionary *userData = @{}; // 上报的附加信息
    if (cost > 5.0f) {
        NSLog(@"%@ cost too much time to be appeared over 5s",key);
        [self fireTimer];
        [ExtentionManager recieveReportDataByCost:cost uri:key userData:userData];
        return;
    }
    // targetType表示检测subview的类型
    if (_targetType == YYViewLoadTimeReportTypeInit) {
        _targetType = [ConfigureReader targetViewType:key];
    }
    
    id subview = [self targetView];
    
    // 是否有其他阻断条件
    if (![ExtentionManager allowDetectingByType:_targetType]) {
        [self fireTimer];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [ExtentionManager performWithTargetView:subview targetType:_targetType completeHandler:^(id  _Nonnull value) {
        __weak typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf fireTimer];
        [ExtentionManager recieveReportDataByCost:cost uri:key userData:userData];
    }];
}

@end
