//
//  LogToolTableViewController.m
//  LogTool
//
//  Created by DingYD on 2019/3/29.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import "LogToolTableViewController.h"
#import "LogToolHeader.h"
@interface LogToolTableViewController ()

@end

@implementation LogToolTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.backgroundColor = LogTool_Color_ViewBackgroundColor_COLOR;
    self.tableView.separatorColor = LogTool_Color_FFFFFF_COLOR;
    self.tableView.tableFooterView = [UIView new];
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self cellToTableView:tableView];
    [cell.textLabel setText:self.dataArray[indexPath.row]];
    return cell;
}

- (UITableViewCell *)cellToTableView:(UITableView *)tableView {
    static NSString * cellID=@"cellID";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = LogTool_Color_ViewBackgroundColor_COLOR;
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.numberOfLines=0;
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13]];
        cell.textLabel.textColor = LogTool_Color_FFFFFF_COLOR;
        cell.detailTextLabel.textColor = LogTool_Color_Tin_COLOR;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[UIViewController new] animated:YES];
}

@end
