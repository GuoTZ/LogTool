//
//  LogToolScreeningTableViewController.m
//  LogTool
//
//  Created by DingYD on 2019/3/30.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import "LogToolScreeningTableViewController.h"
#import "LogToolFileNamesTableViewController.h"
#import "LogToolHomeViewController.h"
@interface LogToolScreeningTableViewController ()

@end

@implementation LogToolScreeningTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    HTTP 1 Info Other 3 Warning 4 Error
    [self configLeftBarButtonItem];
    self.dataArray = @[@"HTTP",@"Info",@"Other",@"Warning",@"Error",@"按文件",@"按时间"].mutableCopy;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self cellToTableView:tableView];
    [cell.textLabel setText:self.dataArray[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string = [self.dataArray objectAtIndex:indexPath.row];
    if (indexPath.row<5) {
        LogToolHomeViewController *vc = [[LogToolHomeViewController alloc]init];
        vc.type = indexPath.row;
        vc.title = string;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row==5) {
        LogToolFileNamesTableViewController *vc = [[LogToolFileNamesTableViewController alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}



@end
