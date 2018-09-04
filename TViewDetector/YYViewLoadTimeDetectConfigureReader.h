//
//  YYViewLoadTimeDetectConfigureReader.h
//  TViewLoadTimeDetectDemo
//
//  Created by 唐鹏 on 2018/8/24.
//  Copyright © 2018年 唐鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,YYTargetViewControllerSubviewType){
    YYTargetViewControllerSubviewTypeListView = 0,
    YYTargetViewControllerSubviewTypeOtherView
};

@interface YYViewLoadTimeDetectConfigureReader : NSObject
+ (instancetype)sharedInstance;
- (NSString *)targetViewWithControllerKey:(NSString *)key;
- (YYTargetViewControllerSubviewType)targetViewType:(NSString *)key;
- (NSDictionary *)configureRootDict;
@end
