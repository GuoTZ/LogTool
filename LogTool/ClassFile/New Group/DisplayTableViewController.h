//
//  DisplayTableViewController.h
//  LogStatistical
//
//  Created by RM on 2018/7/3.
//  Copyright © 2018年 GTZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogStatisticalTableViewController.h"
@interface DisplayTableViewController : LogStatisticalTableViewController<UISearchResultsUpdating>

@property (nonatomic, strong) NSMutableArray *datas;
@end
