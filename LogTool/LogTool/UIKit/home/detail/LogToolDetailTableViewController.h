//
//  LogToolDetailTableViewController.h
//  LogTool
//
//  Created by DingYD on 2019/3/30.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import "LogToolTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class LogToolMessageModel;
@interface LogToolDetailTableViewController : LogToolTableViewController
@property (nonatomic, strong) LogToolMessageModel *model;
@end

NS_ASSUME_NONNULL_END
