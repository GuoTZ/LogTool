//
//  LogToolFileNameDetailViewController.m
//  LogTool
//
//  Created by DingYD on 2019/3/30.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import "LogToolFileNameDetailViewController.h"
#import "LogToolObjectMethodsListVC.h"
#import "LogToolSQLiteManager.h"
#import "LogToolMessageModel.h"
@interface LogToolFileNameDetailViewController ()

@end

@implementation LogToolFileNameDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.file;
    self.pageIndex=1;
    [self downLoadData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"runtime" style:(UIBarButtonItemStylePlain) target:self action:@selector(selectorRuntime)];
}
- (void)selectorRuntime {
    NSArray *array = [self.file componentsSeparatedByString:@"."];
    NSString *className = array.firstObject;
    Class aClass = NSClassFromString(className);
    LogToolObjectMethodsListVC *methodsListController = [[LogToolObjectMethodsListVC alloc] initWithClass:aClass];
    methodsListController.title = className;
    [self.navigationController pushViewController:methodsListController animated:YES];
}

- (void)downLoadData {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (LogToolMessageModel *model in [[LogToolSQLiteManager shareInstance]selectFileNames:self.pageIndex fileName:self.file]) {
            [self.dataArray addObject:model];
        }
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}






- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffsety = scrollView.contentOffset.y;
    CGFloat distance = scrollView.contentSize.height - height;
    if (distance - contentYoffsety < 60) {
        self.pageIndex+=1;
        [self downLoadData];
    }
}



@end
