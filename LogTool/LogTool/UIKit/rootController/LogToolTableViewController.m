//
//  LogToolTableViewController.m
//  LogTool
//
//  Created by DingYD on 2019/3/29.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import "LogToolTableViewController.h"
#import "LogToolHeader.h"
#import "NSDate+LogTool.h"
#import "LogToolDetailTableViewController.h"
@interface LogToolTableViewController ()

@end

@implementation LogToolTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.backgroundColor = LogTool_Color_ViewBackgroundColor_COLOR;
    self.tableView.separatorColor = LogTool_Color_Tin_COLOR;
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
    [self configCellModel:self.dataArray[indexPath.row] cell:cell];
    return cell;
}

- (UITableViewCell *)cellToTableView:(UITableView *)tableView {
    static NSString * cellID=@"cellID";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = LogTool_Color_ViewBackgroundColor_COLOR;
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.numberOfLines=0;
        [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13]];
        cell.detailTextLabel.textColor = LogTool_Color_Tin_COLOR;
        cell.textLabel.textColor = LogTool_Color_Tin_COLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.tintColor = LogTool_Color_Tin_COLOR;
    }
    return cell;
}


- (void)configCellModel:(LogToolMessageModel *)model cell:(UITableViewCell *)cell{
    [cell.detailTextLabel setText:model.formatStrStr];
    NSString *descriptin = @"";
    switch (model.type) {// 0 HTTP 1 Info 2Other 3Warning 4Error
        case 0:
            descriptin = @"  HTTP  ";
            break;
        case 1:
            descriptin = @"  Info  ";
            break;
        case 2:
            descriptin = @"  Other  ";
            break;
        case 3:
            descriptin = @"  Warning  ";
            break;
        case 4:
            descriptin = @"  Error  ";
            break;
        default:
            break;
    }
    [cell.textLabel setText:[NSString stringWithFormat:@"这是一个%@类型的数据\n打印时间:%@\n文件名:%@\n方法名:%@\n方法所在的行数:%d",descriptin,[model.dataStr string_logtool],model.fileStr,model.menthodStr,model.line]];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id model =  [self.dataArray objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[LogToolMessageModel class]]) {
        LogToolDetailTableViewController *vc = [LogToolDetailTableViewController new];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)configLeftBarButtonItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"toolLibs_icon_nav_close@2x"] style:(UIBarButtonItemStylePlain) target:self action:@selector(selectorDismiss)];
}
- (void)selectorDismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
