//
//  LogToolOtherViewController.m
//  LogTool
//
//  Created by DingYD on 2019/3/30.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import "LogToolOtherViewController.h"
#import "LogToolRuntimeViewController.h"
@interface LogToolOtherViewController ()

@end

@implementation LogToolOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = @[@"runtime"].mutableCopy;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self cellToTableView:tableView];
    [cell.textLabel setText:self.dataArray[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string = [self.dataArray objectAtIndex:indexPath.row];
    if (indexPath.row==0) {
        LogToolRuntimeViewController *vc = [[LogToolRuntimeViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row==5) {
        
    }
}




@end
