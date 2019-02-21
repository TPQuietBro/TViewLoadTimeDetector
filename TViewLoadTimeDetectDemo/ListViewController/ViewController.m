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
#import "TempWebviewController.h"
#import "ChildOneViewController.h"
#import "ChildTwoViewController.h"
#import "NoDataViewController.h"

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
        self.dataArray = @[@"click to normalview",@"click to webview",@"click to ChildOneViewController" , @"click to ChildTwoViewController",@"click no data view"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            [indicator removeFromSuperview];
            [self.tableView reloadData];
        });
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            [self.navigationController pushViewController:[TempViewController new] animated:YES];
        }
            break;
        case 1:
        {
            [self.navigationController pushViewController:[TempWebviewController new] animated:YES];
        }
            break;
        case 2:
        {
            [self.navigationController pushViewController:[ChildOneViewController new] animated:YES];
        }
            break;
        case 3:
        {
            [self.navigationController pushViewController:[ChildTwoViewController new] animated:YES];
        }
            break;
        case 4:
        {
            [self.navigationController pushViewController:[NoDataViewController new] animated:YES];
        }
            break;
    }
    
}

@end
