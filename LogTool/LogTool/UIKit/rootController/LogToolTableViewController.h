//
//  LogToolTableViewController.h
//  LogTool
//
//  Created by DingYD on 2019/3/29.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LogToolMessageModel;
@interface LogToolTableViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger pageIndex;
- (UITableViewCell *)cellToTableView:(UITableView *)tableView;
- (void)configCellModel:(LogToolMessageModel *)model cell:(UITableViewCell *)cell;
- (void)configLeftBarButtonItem ;
@end

NS_ASSUME_NONNULL_END
