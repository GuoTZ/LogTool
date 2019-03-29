//
//  RecentsTableViewController.m
//  LogStatistical
//
//  Created by RM on 2018/6/23.
//  Copyright © 2018年 GTZ. All rights reserved.
//

#import "RecentsTableViewController.h"
#import "LogMessage.h"
#import "SQLiteToolManager.h"
#import "SQLiteModel.h"
#import "DetailTableViewController.h"
@interface RecentsTableViewController ()
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, copy) NSArray<NSString *> *titleArr;
@end

@implementation RecentsTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageIndex = 1;
    [self downData];
    if (self.typeIndex>0) {
        self.navigationItem.leftBarButtonItem = nil;
    }
    self.titleArr = @[@"首页",@"error",@"Info",@"Warning",@"Http",@"Other"];
    self.navigationItem.title = self.titleArr[_typeIndex];
}

- (void)downData {
    if (self.typeIndex == 0) {
        for (SQLiteModel *model in [[SQLiteToolManager shareInstance]select:self.pageIndex]) {
            [self.dataArray addObject:model];
            [self.tableView reloadData];
        }
    } else {
        for (SQLiteModel *model in [[SQLiteToolManager shareInstance]select:self.pageIndex type:self.typeIndex-1]) {
            [self.dataArray addObject:model];
            [self.tableView reloadData];
        }
    }
}

- (void)setTypeIndex:(NSInteger)typeIndex{
    _typeIndex = typeIndex+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    SQLiteModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"这是一个%@信息%@",self.titleArr[model.type + 1],model.msg];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LogStatistical" bundle:nil];
    DetailTableViewController *vc = [sb instantiateViewControllerWithIdentifier:@"DetailTableViewControllerID"];
    SQLiteModel *model = [self.dataArray objectAtIndex:indexPath.row];
    vc.detailStr = [NSString stringWithFormat:@"这是一个%@信息%@",self.titleArr[model.type + 1],model.msg];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffsety = scrollView.contentOffset.y;
    CGFloat distance = scrollView.contentSize.height - height;
    if (distance - contentYoffsety < 60) {
        self.pageIndex += 1;
        [self downData];
    }
}
@end
