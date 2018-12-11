//
//  TListViewExtesion.m
//  TViewLoadTimeDetectDemo
//
//  Created by 唐鹏 on 2018/12/11.
//  Copyright © 2018 唐鹏. All rights reserved.
//

#import "TListViewExtesion.h"

@implementation TListViewExtesion
- (void)excuteConditionWithTargetView:(id)targetView completionBlock:(void (^)(id callBackValue))block{
    [super excuteConditionWithTargetView:targetView completionBlock:block];
    
    if ([targetView isKindOfClass:[UITableView class]] || [targetView isKindOfClass:[UICollectionView class]]) {
        
        NSArray *visibleCells = [targetView performSelector:@selector(visibleCells)];
        
        if (visibleCells.count > 0) {
            
            SAFE_BLOCK(block,@(visibleCells.count));
        }
    }
}

- (NSInteger)type{
    return YYViewLoadTimeReportTypeListView;
}

- (BOOL)allowDetecting{
    return YES;
}

- (void)reportData{
    [super reportData];
}
@end
