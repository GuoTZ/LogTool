//
//  LogToolNavViewController.m
//  LogTool
//
//  Created by DingYD on 2019/3/29.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import "LogToolNavViewController.h"
#import "LogToolHeader.h"
@interface LogToolNavViewController ()

@end

@implementation LogToolNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBarTintColor:LogTool_Color_ViewBackgroundColor_COLOR];
    [self.navigationBar setTintColor:LogTool_Color_Tin_COLOR];
    // 通过appearence设置导航栏全局色

    //标题色
    NSDictionary *titleAttrs = @{NSForegroundColorAttributeName:LogTool_Color_Tin_COLOR,NSFontAttributeName:[UIFont systemFontOfSize:18]};
    [self.navigationBar setTitleTextAttributes:titleAttrs];
    self.navigationBar.translucent = NO;
}

/**
 * 可以拦截所有push进来的内容
 *
 *  @param viewController push进的VC
 *  @param animated       是否有动画效果
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}
@end
