//
//  LogToolFileNamesTableViewController.m
//  LogTool
//
//  Created by DingYD on 2019/3/30.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import "LogToolFileNamesTableViewController.h"
#import "LogToolSQLiteManager.h"
#import "LogToolMessageModel.h"
#import "LogToolFileNameDetailViewController.h"
@interface LogToolFileNamesTableViewController ()

@end

@implementation LogToolFileNamesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"文件";
    [self downLoadData];
}
- (void)downLoadData {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (LogToolMessageModel *model in [[LogToolSQLiteManager shareInstance]selectFileNames]) {
            [self.dataArray addObject:model];
        }
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self cellToTableView:tableView];
    LogToolMessageModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:model.fileStr.length?model.fileStr:@"数据异常"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LogToolFileNameDetailViewController *vc = [[LogToolFileNameDetailViewController alloc]init];
    LogToolMessageModel *model = [self.dataArray objectAtIndex:indexPath.row];
    vc.file = model.fileStr.length?model.fileStr:@"数据异常";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
