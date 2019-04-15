//
//  LogToolRuntimeViewController.m
//  LogTool
//
//  Created by DingYD on 2019/3/30.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import "LogToolRuntimeViewController.h"
#import "LogToolObjectMethodsListVC.h"
#import "LogToolHeader.h"
#import <objc/runtime.h>
@interface LogToolRuntimeViewController ()<UISearchResultsUpdating>
@property(nonatomic, strong) NSMutableArray<NSString *> *allClasses;
@property(nonatomic, strong) NSMutableArray<NSString *> *autocompletionClasses;
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation LogToolRuntimeViewController
- (NSMutableArray<NSString *> *)allClassesArray {
    NSMutableArray<NSString *> *allClasses = [[NSMutableArray alloc] init];
    Class *classes = nil;
    int numberOfClasses = objc_getClassList(nil, 0);
    if (numberOfClasses > 0) {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numberOfClasses);
        numberOfClasses = objc_getClassList(classes, numberOfClasses);
        for (int i = 0; i < numberOfClasses; i++) {
            Class c = classes[i];
            [allClasses addObject:NSStringFromClass(c)];
        }
        free(classes);
    }
    return allClasses;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建用于展示搜索结果的控制器
    // 创建搜索框
    self.autocompletionClasses =@[].mutableCopy;
    UISearchController *search = [[UISearchController alloc]initWithSearchResultsController:nil];
    search = [[UISearchController alloc] initWithSearchResultsController:nil];
    search.searchBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44);
    [search.searchBar sizeToFit];
    search.searchBar.barTintColor = LogTool_Color_ViewBackgroundColor_COLOR;
    search.searchBar.tintColor = LogTool_Color_Tin_COLOR;
    UIButton *canceLBtn = [search.searchBar valueForKey:@"cancelButton"];
    [canceLBtn setTitle:@"取消" forState:UIControlStateNormal];
    for (UIView *subView in [[search.searchBar.subviews lastObject] subviews]){
        if ([subView isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)subView;
            textField.backgroundColor = [UIColor logtool_colorWithHexString:@"#333333" alpha:0.5];
            //修改输入的字体的颜色
            textField.font = [UIFont systemFontOfSize:14];
            textField.textColor = LogTool_Color_Tin_COLOR;
            //修改placeholder的颜色
            [textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)subView;
            [btn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
    search.searchBar.placeholder = @"请输入 Class 名称，不区分大小写";
    //    search.dimsBackgroundDuringPresentation = NO;
    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed
    self.tableView.tableHeaderView = search.searchBar;
    search.searchResultsUpdater = self;
    //搜索时，背景变模糊
    search.obscuresBackgroundDuringPresentation = NO;
    self.searchController = search;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.allClasses = [self allClassesArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (double)matchingWeightForResult:(NSString *)className withSearchString:(NSString *)searchString {
    /**
     排序方式：
     1. 每个 className 都有一个基准的匹配权重，权重取值范围 [0-1]，这个权重简单地以字符串长度来计算，匹配到的 className 里长度越短的 className 认为匹配度越高
     2. 基于步骤 1 得到的匹配权重进行分段，以搜索词开头的 className 权重最高，以下划线开头的 className 权重最低（如果搜索词本来就以下划线开头则不计入此种情况），其他情况权重中等。
     3. 特别的，如果 className 与搜索词完全匹配，则权重最高，为 1
     4. 最终权重越高者排序越靠前
     */
    
    className = className.lowercaseString;
    searchString = searchString.lowercaseString;
    
    if ([className isEqualToString:searchString]) {
        return 1;
    }
    
    double matchingWeight = (double)searchString.length / (double)className.length;
    if ([className hasPrefix:searchString]) {
        return matchingWeight * 1.0 / 3.0 + 2.0 / 3.0;
    }
    if ([className hasPrefix:@"_"] && ![searchString hasPrefix:@"_"]) {
        return matchingWeight * 1.0 / 3.0;
    }
    matchingWeight = matchingWeight * 1.0 / 3.0 + 1.0 / 3.0;
    
    return matchingWeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.autocompletionClasses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self cellToTableView:tableView];
    NSString *className = self.autocompletionClasses[indexPath.row];
    NSRange matchingRange = [className.lowercaseString rangeOfString:self.searchController.searchBar.text.lowercaseString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:className attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: LogTool_Color_Tin_COLOR}];
    [attributedString addAttribute:NSForegroundColorAttributeName value:LogTool_Color_FFFFFF_COLOR range:matchingRange];
    cell.textLabel.attributedText = attributedString;
//    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = self.autocompletionClasses[indexPath.row];
    Class aClass = NSClassFromString(className);
    LogToolObjectMethodsListVC *methodsListController = [[LogToolObjectMethodsListVC alloc] initWithClass:aClass];
    methodsListController.title = className;
    [self.navigationController pushViewController:methodsListController animated:YES];
}

#pragma mark - <QMUISearchControllerDelegate>
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    [self.autocompletionClasses removeAllObjects];
    
    if (searchController.searchBar.text.length > 2) {
        for (NSString *className in self.allClasses) {
            if ([className.lowercaseString containsString:searchController.searchBar.text.lowercaseString]) {
                [self.autocompletionClasses addObject:className];
            }
        }
        
        [self.autocompletionClasses sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            double matchingWeight1 = [self matchingWeightForResult:obj1 withSearchString:searchController.searchBar.text];
            double matchingWeight2 = [self matchingWeightForResult:obj2 withSearchString:searchController.searchBar.text];
            NSComparisonResult result = matchingWeight1 == matchingWeight2 ? NSOrderedSame : (matchingWeight1 > matchingWeight2 ? NSOrderedAscending : NSOrderedDescending);
            return result;
        }];
    }
    
    [self.tableView reloadData];
}




@end
