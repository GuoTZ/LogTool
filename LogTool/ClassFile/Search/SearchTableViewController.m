//
//  SearchTableViewController.m
//  LogStatistical
//
//  Created by RM on 2018/6/23.
//  Copyright © 2018年 GTZ. All rights reserved.
//

#import "SearchTableViewController.h"
#import "RecentsTableViewController.h"
#import "SearchDetailTableViewController.h"
@interface SearchTableViewController ()

@end

@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.dataArray addObject:@"error"];
    [self.dataArray addObject:@"Info"];
    [self.dataArray addObject:@"Warning"];
    [self.dataArray addObject:@"Http"];
    [self.dataArray addObject:@"Other"];
    [self.dataArray addObject:@"Search"];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==5) {
        SearchDetailTableViewController *vc = [[SearchDetailTableViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    RecentsTableViewController *vc = [[RecentsTableViewController alloc]init];
    vc.typeIndex = indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
