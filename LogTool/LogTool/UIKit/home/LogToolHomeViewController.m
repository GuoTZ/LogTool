//
//  LogToolHomeViewController.m
//  LogTool
//
//  Created by DingYD on 2019/3/29.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import "LogToolHomeViewController.h"
#import "LogToolHeader.h"
#import "LogToolSQLiteManager.h"
#import "LogToolDetailTableViewController.h"
@interface LogToolHomeViewController ()<UISearchResultsUpdating,UISearchBarDelegate,UISearchControllerDelegate>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, strong) NSMutableArray *seacrhArray;
@property (nonatomic, assign) NSInteger seacrhIndex;
@end

@implementation LogToolHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建用于展示搜索结果的控制器
    // 创建搜索框
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
    search.searchBar.placeholder = @"请输入关键词";
//    search.dimsBackgroundDuringPresentation = NO;
    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed
    self.tableView.tableHeaderView = search.searchBar;
    search.searchResultsUpdater = self;
    //搜索时，背景变模糊
    search.obscuresBackgroundDuringPresentation = NO;
    search.searchBar.delegate = self;
    search.searchResultsUpdater = self;
    search.delegate = self;
    self.searchController = search;
    

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    //产生100个“数字+三个随机字母”
    self.pageIndex=1;
    [self downLoadData];
    self.seacrhIndex = 1;
    self.seacrhArray = @[].mutableCopy;
    if (self.type<0) {
        [self configLeftBarButtonItem];
    }
    [self configRightBarButtonItem];
}

- (void)configRightBarButtonItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"toolLibs_icon_nav_detele@2x"] style:(UIBarButtonItemStylePlain) target:self action:@selector(selectorDetele)];
}
- (void)selectorDetele {
    NSString *msg = self.title;
    if (self.type<0) {
        msg = @"全部";
    }
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"是否删除%@日志信息",msg] preferredStyle:(UIAlertControllerStyleAlert)];
    [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alter addAction:[UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[LogToolSQLiteManager shareInstance] deleteType:self.type];
            [self.dataArray removeAllObjects];
            self.pageIndex=1;
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        });
    }]];
    [self presentViewController:alter animated:YES completion:nil];
}

- (void)downLoadData {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (LogToolMessageModel *model in [[LogToolSQLiteManager shareInstance]select:self.pageIndex type:self.type]) {
            [self.dataArray addObject:model];
        }
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}


- (void)searchData {
    NSString *st = self.searchController.searchBar.text;
    if (st.length==0) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (LogToolMessageModel *model in [[LogToolSQLiteManager shareInstance]select:self.pageIndex keyWord:st type:self.type]) {
            [self.seacrhArray addObject:model];
        }
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self cellToTableView:tableView];
    if (self.isSearch) {
        LogToolMessageModel *model =  [self.seacrhArray objectAtIndex:indexPath.row];
        [self configCellModel:model cell:cell];
    } else {
        LogToolMessageModel *model =  [self.dataArray objectAtIndex:indexPath.row];
        [self configCellModel:model cell:cell];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSearch) {
        id model =  [self.seacrhArray objectAtIndex:indexPath.row];
        if ([model isKindOfClass:[LogToolMessageModel class]]) {
            LogToolDetailTableViewController *vc = [LogToolDetailTableViewController new];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        id model =  [self.dataArray objectAtIndex:indexPath.row];
        if ([model isKindOfClass:[LogToolMessageModel class]]) {
            LogToolDetailTableViewController *vc = [LogToolDetailTableViewController new];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearch) {
        return [self.seacrhArray count];
    } else {
        return [self.dataArray count];
    }
}

- (void)willPresentSearchController:(UISearchController *)searchController{
    self.isSearch = YES;
    self.seacrhIndex=1;
    [self.seacrhArray removeAllObjects];
    [self.tableView reloadData];
}
- (void)willDismissSearchController:(UISearchController *)searchController{
    self.isSearch = NO;
    [self.tableView reloadData];
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    //第二组可以左滑删除
    return YES;
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        LogToolMessageModel *model = [self.dataArray objectAtIndex:indexPath.row];
        if ([[LogToolSQLiteManager shareInstance]deleteId:model.Id]) {
            [self.dataArray removeObject:model];
            [self.tableView reloadData];
        }
        
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

@end
