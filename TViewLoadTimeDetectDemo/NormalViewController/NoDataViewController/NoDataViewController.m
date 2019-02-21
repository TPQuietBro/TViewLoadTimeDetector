//
//  NoDataViewController.m
//  TViewLoadTimeDetectDemo
//
//  Created by 唐鹏 on 2019/2/21.
//  Copyright © 2019 唐鹏. All rights reserved.
//

#import "NoDataViewController.h"

@interface NoDataView : UIView
@end

@implementation NoDataView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [UILabel new];
        label.text = @"no data";
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        label.frame = CGRectMake((frame.size.width - 100) * 0.5, (frame.size.height - 25) * 0.5, 100, 25);
    }
    return self;
}
@end

@interface DataView : UIView
@end

@implementation DataView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [UILabel new];
        label.text = @"has data";
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        label.frame = CGRectMake((frame.size.width - 100) * 0.5, (frame.size.height - 25) * 0.5, 100, 25);
    }
    return self;
}
@end

@interface NoDataViewController ()<UITableViewDataSource>
@property (nonatomic, strong) NSArray *datas;
@end

@implementation NoDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datas = @[];
    [self conditionForTableview];
//    [self conditionForNormalView];
    
}

- (void)conditionForNormalView{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake((self.view.frame.size.width - 60) * 0.5, (self.view.frame.size.height - 60) * 0.5, 60, 60);
    [self.view addSubview:indicator];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(2);
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            
            if (self.datas.count == 0) {
                NoDataView *view = [[NoDataView alloc] initWithFrame:self.view.bounds];
                view.backgroundColor = [UIColor lightGrayColor];
                [self.view addSubview:view];
            } else {
                DataView *dataView = [[DataView alloc] initWithFrame:self.view.frame];
                dataView.backgroundColor = [UIColor redColor];
                [self.view addSubview:dataView];
            }
        });
    });
}

- (void)conditionForTableview{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.dataSource = self;
    //    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:tableView];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake((self.view.frame.size.width - 60) * 0.5, (self.view.frame.size.height - 60) * 0.5, 60, 60);
    [self.view addSubview:indicator];
    
    [indicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(2);
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            if (self.datas.count == 0) {
                NoDataView *view = [[NoDataView alloc] initWithFrame:tableView.bounds];
                view.backgroundColor = [UIColor lightGrayColor];
                [tableView addSubview:view];
            }
        });
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UITableViewCell new];
}

@end
