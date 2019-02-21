//
//  UIViewController+YYViewLoadTime.m
//  KVODemo
//
//  Created by 唐鹏 on 2018/8/21.
//  Copyright © 2018年 唐鹏. All rights reserved.
//

#import "UIViewController+YYViewLoadTime.h"
#import "YYViewLoadTimeDetectConfigureReader.h"
#import "UIView+ViewInScreen.h"
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
static NSString *_parentVc = nil;
static UIView *_targetView = nil;

@implementation UIViewController (Util)

- (void)preInit{
    UIViewController *selfInstance = self;
    _preViewController = selfInstance;
}

// 找到需要检测的子view,递归实现,注意子控件深度,尽量浅,避免大于每帧的16.67ms
- (UIView *)targetView{
    if (_targetView) {
        return _targetView;
    }
    NSString *key = NSStringFromClass([self class]);
    NSString *targetViewType = [ConfigureReader targetViewWithControllerKey:_parentVc ? _parentVc : key];
    NSArray *subviews = self.view.subviews;
    
    return [self subviewInSubviews:subviews targetViewType:targetViewType];;
}
// 递归获取子view
- (UIView *)subviewInSubviews:(NSArray *)subviews targetViewType:(NSString *)targetViewType{
    // 判断self.view的类型是因为可能重写loadview或者直接将self.view强制赋值
    if ([self.view isKindOfClass:NSClassFromString(targetViewType)]) {
        _targetView = self.view;
        return self.view;
    }
    // 广度遍历
    for (UIView *subView in subviews) {
        if ([subView isKindOfClass:NSClassFromString(targetViewType)]) {
            _targetView = subView;
            return subView;
        }
    }
    // 深度遍历 ,到这里可能会造成误差,所以subview的层级最好是一层
    for (UIView *subview in subviews) {
        while (subview.subviews) {
            return [self subviewInSubviews:subview.subviews targetViewType:targetViewType];
        }
    }
    return nil;
}

// 是否是需要检测的控制器
- (BOOL)isTargetVc{
    NSArray *allKeys = [self targetControllerKeys];
    NSString *key = NSStringFromClass([self class]);
    if ([allKeys containsObject:key]) {
        return YES;
    }
    // 如果想统一处理继承自某个父控制器的页面
    BOOL isParentVcContained = [self isParentViewControllerContainedWithAllKeys:allKeys subClass:[self class]];
    if (isParentVcContained) {
        return YES;
    }
    return NO;
}

- (BOOL)isParentViewControllerContainedWithAllKeys:(NSArray *)allKeys subClass:(Class)subClass{
    if (subClass.superclass) {
        NSString *parentVc = NSStringFromClass(subClass.superclass);
        if ([allKeys containsObject:parentVc]) {
            _parentVc = parentVc;
            return YES;
        }
        [self isParentViewControllerContainedWithAllKeys:allKeys subClass:subClass.superclass];
    }
    return NO;
}

// 所有需要检测的控制器名称
- (NSArray *)targetControllerKeys{
    NSDictionary *configDict = [ConfigureReader configureRootDict];
#if debug
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
    _targetView = nil;
    _preViewController = nil;
}

- (BOOL)hasFilteredCustomizeConditions{
    if (![self isTargetVc] || [_preViewController isEqual:self]) {
        return NO;
    }
    return YES;
}

- (void)initDate{
    NSDate *date = [NSDate date];
    _date = date;
}

- (void)startTimerWithSelector:(SEL)selector{
    CADisplayLink *timer = [CADisplayLink displayLinkWithTarget:self selector:selector];
    [timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    _timer = timer;
}

@end

@implementation UIViewController (YYViewLoadTime)

+ (void)load{
#if DEBUG
    [self swizzleSEL:@selector(viewDidLoad) withSEL:@selector(my_viewDidLoad)];
#endif
}

- (void)my_viewDidLoad{
    // 非要监听的控制器不需要添加定时器
    if (![self hasFilteredCustomizeConditions]) {
        [self my_viewDidLoad];
        return;
    }
    [self fireTimer];
    
    [self addExtensions];
    
    [self preInit];
    
    [self initDate];
    
    [self startTimerWithSelector:@selector(detecting:)];
    
    [self my_viewDidLoad];
    
    NSLog(@"%@ start timer",[self class]);
}

// 检测方法
- (void)detecting:(CADisplayLink *)timer{
    
    id subview = [self targetView];
    NSString *key = NSStringFromClass([self class]);
    // 如果检测到消耗时间大于5s就提个醒,5s可以是其他值
    NSTimeInterval cost = [[NSDate date] timeIntervalSinceDate:_date];
    
    NSDictionary *userData = @{}; // 上报的附加信息
    if (cost > 5.0f) {
        [self fireTimer];
        [ExtentionManager recieveReportDataByCost:cost uri:key userData:userData];
        return;
    }
    // targetType表示检测subview的类型
    if (_targetType == YYViewLoadTimeReportTypeInit) {
        _targetType = [ConfigureReader targetViewType:_parentVc ? _parentVc :key];
        _parentVc = nil;
    }
    
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
