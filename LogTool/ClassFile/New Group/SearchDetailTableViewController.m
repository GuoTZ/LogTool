//
//  SearchDetailTableViewController.m
//  LogStatistical
//
//  Created by RM on 2018/7/3.
//  Copyright © 2018年 GTZ. All rights reserved.
//

#import "SearchDetailTableViewController.h"
#import "DisplayTableViewController.h"
@interface SearchDetailTableViewController ()

@property (nonatomic, strong) DisplayTableViewController *displayController;
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation SearchDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    // 创建用于展示搜索结果的控制器
    DisplayTableViewController *result = [[DisplayTableViewController alloc]init];
    
    // 创建搜索框
    UISearchController *search = [[UISearchController alloc]initWithSearchResultsController:result];
    
    self.tableView.tableHeaderView = search.searchBar;
    
    search.searchResultsUpdater = result;
    
    self.searchController = search;
    
    search.searchBar.placeholder = @"搜索";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
}

@end
