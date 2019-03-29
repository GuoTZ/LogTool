//
//  DetailTableViewController.m
//  LogStatistical
//
//  Created by RM on 2018/7/3.
//  Copyright © 2018年 GTZ. All rights reserved.
//

#import "DetailTableViewController.h"
#import <Social/Social.h>
@interface DetailTableViewController ()

@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    self.title = @"Detail";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:(UIBarButtonItemStyleDone) target:self action:@selector(shareAction)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

/**
 分享
 */
- (void)shareAction {
    NSArray *activityArray = @[self.detailStr];
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:activityArray applicationActivities:nil];

    [self presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    cell.textLabel.text = self.detailStr;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
