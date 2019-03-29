//
//  RecentsTableViewController.h
//  LogStatistical
//
//  Created by RM on 2018/6/23.
//  Copyright © 2018年 GTZ. All rights reserved.
//

#import "LogStatisticalTableViewController.h"
#import "LogMessage.h"
@interface RecentsTableViewController : LogStatisticalTableViewController

/**
 不传值表示查询所有
 */
@property (nonatomic,assign) NSInteger typeIndex;
@end
