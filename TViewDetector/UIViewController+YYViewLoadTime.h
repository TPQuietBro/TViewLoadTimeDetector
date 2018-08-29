//
//  UIViewController+YYViewLoadTime.h
//  KVODemo
//
//  Created by 唐鹏 on 2018/8/21.
//  Copyright © 2018年 唐鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/message.h>
@interface NSObject (Swizzling)
+ (void)swizzleSEL:(SEL)originalSEL withSEL:(SEL)swizzledSEL;
@end

@interface UIViewController (YYViewLoadTime)
@end
