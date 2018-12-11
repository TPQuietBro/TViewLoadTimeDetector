//
//  TBaseExtension.m
//  TViewLoadTimeDetectDemo
//
//  Created by 唐鹏 on 2018/12/11.
//  Copyright © 2018 唐鹏. All rights reserved.
//

#import "TBaseExtension.h"
#define DEFAULT_CONSUME_LIMIT 5

@implementation TBaseExtension
- (void)excuteConditionWithTargetView:(id)targetView completionBlock:(void (^)(id callBackValue))block{
    self.targetView = targetView;
}

- (NSInteger)type{
    return YYViewLoadTimeReportTypeInit;
}

- (void)reportData{
    if (self.cost <= DEFAULT_CONSUME_LIMIT) {
        NSLog(@"%@ %@ cost %lf to be appeared", _uri,[_targetView class],_cost);
    } else {
        NSLog(@"warning: %@ targetView %@ cost over 5s",_uri,[_targetView class]);
    }
}
@end
