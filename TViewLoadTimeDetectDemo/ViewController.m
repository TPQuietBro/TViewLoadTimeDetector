//
//  ViewController.m
//  TViewLoadTimeDetectDemo
//
//  Created by 唐鹏 on 2018/8/24.
//  Copyright © 2018年 唐鹏. All rights reserved.
//

#import "ViewController.h"
#import "TempCell.h"
#import "TempViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@end

static NSString *const TempCellId = @"TempCell";
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[TempCell class] forCellReuseIdentifier:TempCellId];
    
    [self asyncReload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TempCell *cell = [tableView dequeueReusableCellWithIdentifier:TempCellId];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)asyncReload{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake((self.view.frame.size.width - 60) * 0.5, (self.view.frame.size.height - 60) * 0.5, 60, 60);
    [self.view addSubview:indicator];
    [indicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(3);
        self.dataArray = @[@"123",@"456",@"789"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            [indicator removeFromSuperview];
            [self.tableView reloadData];
        });
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController pushViewController:[TempViewController new] animated:YES];
}

@end
