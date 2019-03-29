//
//  LogStatisticalTableViewController.m
//  LogStatistical
//
//  Created by RM on 2018/6/23.
//  Copyright © 2018年 GTZ. All rights reserved.
//

#import "LogStatisticalTableViewController.h"
#import "LogMessage.h"
@interface LogStatisticalTableViewController ()

@end

@implementation LogStatisticalTableViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataArray];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellID"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"く返回" style:UIBarButtonItemStyleDone target:self action:@selector(selectorBack)];
    
    [self.tableView reloadData];
    
    for (int i=0; i<5; i++) {
        LogError(@"error");
        LogInfo(@"Info");
        LogWarning(@"Warning");
        LogHttp(@"Http");
        LogOther(@"Other");
    }
    
    
}
- (void)selectorBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

@end
