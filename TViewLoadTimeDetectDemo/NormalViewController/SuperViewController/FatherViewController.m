//
//  FatherViewController.m
//  TViewLoadTimeDetectDemo
//
//  Created by 唐鹏 on 2019/2/21.
//  Copyright © 2019 唐鹏. All rights reserved.
//

#import "FatherViewController.h"

@interface SuperView : UIView

@end

@implementation SuperView

@end

@interface FatherViewController ()

@end

@implementation FatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SuperView *view = [SuperView new];
    view.backgroundColor = [UIColor redColor];
    view.frame = CGRectMake(10, 60, 50, 100);
    [self.view addSubview:view];
}

@end
