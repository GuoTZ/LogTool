//
//  LogToolHomeViewController.m
//  LogTool
//
//  Created by DingYD on 2019/3/29.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import "LogToolHomeViewController.h"
#import "LogToolSearchViewController.h"
#import "LogToolHeader.h"
@interface LogToolHomeViewController ()<UISearchResultsUpdating>
@property (nonatomic, strong) NSMutableArray *searchList;
@property (nonatomic, strong) LogToolSearchViewController *displayController;
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation LogToolHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建用于展示搜索结果的控制器
    LogToolSearchViewController *result = [[LogToolSearchViewController alloc]init];
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
    search.dimsBackgroundDuringPresentation = NO;
    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed
    self.tableView.tableHeaderView = search.searchBar;
    search.searchResultsUpdater = result;
    self.definesPresentationContext = YES;
    //搜索时，背景变模糊
    search.obscuresBackgroundDuringPresentation = YES;
    self.searchController = search;
    search.searchBar.placeholder = @"搜索";
    _searchController.searchResultsUpdater= self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    //产生100个“数字+三个随机字母”
    for (NSInteger i=0; i<100; i++) {
        [self.dataArray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"toolLibs_icon_nav_close@2x"] style:(UIBarButtonItemStylePlain) target:self action:@selector(selectorDismiss)];
}
- (void)selectorDismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSLog(@"updateSearchResultsForSearchController");
    NSString *searchString = [self.searchController.searchBar text];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    //过滤数据
    self.searchList= [NSMutableArray arrayWithArray:[self.dataArray filteredArrayUsingPredicate:preicate]];
    //刷新表格
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return [self.searchList count];
    }else{
        return [self.dataArray count];
    }
}
//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[self cellToTableView:tableView];
    if (self.searchController.active) {
        [cell.textLabel setText:self.searchList[indexPath.row]];
    }
    else{
        [cell.textLabel setText:self.dataArray[indexPath.row]];
    }
    return cell;
}




@end
