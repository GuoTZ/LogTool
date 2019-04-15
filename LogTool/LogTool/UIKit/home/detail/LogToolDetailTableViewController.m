//
//  LogToolDetailTableViewController.m
//  LogTool
//
//  Created by DingYD on 2019/3/30.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import "LogToolDetailTableViewController.h"
#import "LogToolMessageModel.h"
#import "NSDate+LogTool.h"
@interface LogToolDetailTableViewController ()

@end

@implementation LogToolDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详情";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:(UIBarButtonItemStylePlain) target:self action:@selector(selectorShare)];
}
- (void)selectorShare {
    NSString *descriptin = @"";
    switch (self.model.type) {// 0 HTTP 1 Info 2Other 3Warning 4Error
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
    NSString *string = [NSString stringWithFormat:@"这是一个%@类型的数据\n打印时间:%@\n文件名:%@\n方法名:%@\n方法所在的行数:%d\n\n\n内容:\n%@",descriptin,[self.model.dataStr string_logtool],self.model.fileStr,self.model.menthodStr,self.model.line,self.model.formatStrStr];
    NSArray *activityArray = @[string];
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:activityArray applicationActivities:nil];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self cellToTableView:tableView];
    NSString *descriptin = @"";
    switch (self.model.type) {// 0 HTTP 1 Info 2Other 3Warning 4Error
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
    [cell.textLabel setText:[NSString stringWithFormat:@"这是一个%@类型的数据\n打印时间:%@\n文件名:%@\n方法名:%@\n方法所在的行数:%d\n\n\n内容:\n%@",descriptin,[self.model.dataStr string_logtool],self.model.fileStr,self.model.menthodStr,self.model.line,self.model.formatStrStr]];
    
    return cell;
}



@end
