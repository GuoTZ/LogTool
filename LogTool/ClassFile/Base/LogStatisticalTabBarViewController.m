//
//  LogStatisticalTabBarViewController.m
//  LogStatistical
//
//  Created by RM on 2018/6/23.
//  Copyright © 2018年 GTZ. All rights reserved.
//

#import "LogStatisticalTabBarViewController.h"
#import "LogStatistical.h"
@interface LogStatisticalTabBarViewController ()

@end

@implementation LogStatisticalTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[LogStatistical shareInstance]hiddenButton];
}


- (void)dealloc {
    [[LogStatistical shareInstance]showButton];
}

@end
