//
//  DisplayTableViewController.m
//  LogStatistical
//
//  Created by RM on 2018/7/3.
//  Copyright © 2018年 GTZ. All rights reserved.
//

#import "DisplayTableViewController.h"
#import "SQLiteToolManager.h"
#import "SQLiteModel.h"
#import "DetailTableViewController.h"
@interface DisplayTableViewController ()
@property (nonatomic, strong) NSString *inputStr;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, copy) NSArray<NSString *> *titleArr;
@end

@implementation DisplayTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageIndex = 1;
    self.titleArr = @[@"首页",@"error",@"Info",@"Warning",@"Http",@"Other"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"resultCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
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

-(void)seleKeyWord {
    for (SQLiteModel *model in [[SQLiteToolManager shareInstance]select:self.pageIndex keyWord:self.inputStr]) {
        [self.dataArray addObject:model];
        [self.tableView reloadData];
    }
    [self.tableView reloadData];
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    self.inputStr = searchController.searchBar.text ;
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    [self seleKeyWord];
}
                                
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffsety = scrollView.contentOffset.y;
    CGFloat distance = scrollView.contentSize.height - height;
    if (distance - contentYoffsety < 60) {
        self.pageIndex += 1;
        [self seleKeyWord];
    }
}
                                
                                
@end
