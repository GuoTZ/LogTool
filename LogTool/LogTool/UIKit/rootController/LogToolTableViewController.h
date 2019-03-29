//
//  LogToolTableViewController.h
//  LogTool
//
//  Created by DingYD on 2019/3/29.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogToolTableViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *dataArray;
- (UITableViewCell *)cellToTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
