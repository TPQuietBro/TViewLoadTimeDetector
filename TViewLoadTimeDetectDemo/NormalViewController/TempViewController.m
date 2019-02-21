//
//  TempViewController.m
//  TViewLoadTimeDetectDemo
//
//  Created by 唐鹏 on 2018/8/28.
//  Copyright © 2018年 唐鹏. All rights reserved.
//

#import "TempViewController.h"
#import "TempView.h"
@interface TempViewController ()

@end

@implementation TempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(3);
        dispatch_async(dispatch_get_main_queue(), ^{
            TempView *tView = [[TempView alloc] init];
            tView.frame = CGRectMake(10, 20, 300, 200);
            tView.backgroundColor = [UIColor orangeColor];
            [self.view addSubview:tView];
        });
    });
}


@end
