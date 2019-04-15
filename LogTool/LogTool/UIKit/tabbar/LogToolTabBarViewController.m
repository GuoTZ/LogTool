//
//  LogToolTabBarViewController.m
//  LogTool
//
//  Created by DingYD on 2019/3/29.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import "LogToolTabBarViewController.h"
#import "LogToolTableViewController.h"
#import "LogToolHeader.h"
#import "LogToolNavViewController.h"
#import "LogToolHomeViewController.h"
#import "LogToolScreeningTableViewController.h"
#import "LogToolOtherViewController.h"
#import "LogToolStatistical.h"
@interface LogToolTabBarViewController ()

@end

@implementation LogToolTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tabBar setBackgroundImage:[UIImage logtool_imageWithColor:UIColor.blackColor]];
    [self.tabBar setBackgroundColor:[UIColor clearColor]];
    [self.tabBar setTintColor:[UIColor whiteColor]];
    [self.tabBar setTranslucent:NO];
    [self.tabBar setShadowImage:[[UIImage alloc] init]];
    
    
    

    LogToolHomeViewController *homeViewController = [[LogToolHomeViewController alloc]init];
    homeViewController.type = -1;
    [self addchildControllersWithViewController:homeViewController Title:@"首页" image:@"toolLibs_home_icon@2x" ];
    

    LogToolScreeningTableViewController *serviceViewController = [[LogToolScreeningTableViewController alloc]init];
    [self addchildControllersWithViewController:serviceViewController Title:@"筛选" image:@"toolLibs_select_icon@2x" ];
    
    

//    LogToolTableViewController *forumViewController = [[LogToolTableViewController alloc]init];
//    [self addchildControllersWithViewController:forumViewController Title:@"设置" image:@"toolLibs_seting_icon@2x" ];
    

    LogToolOtherViewController *meViewController = [[LogToolOtherViewController alloc] init];
    [self addchildControllersWithViewController:meViewController Title:@"其他" image:@"toolLibs_other_icon@2x"];
    [[LogToolStatistical shareInstance]hiddenButton];
}


- (void)dealloc {
    [[LogToolStatistical shareInstance]showButton];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  添加子控制器
 */
- (void)addchildControllersWithViewController:(UIViewController*)vc Title:(NSString *)title image:(NSString *)image {
    vc.title = title;
    vc.tabBarItem.image = [[[UIImage imageNamed:image] logtool_imageWithTintColor:[UIColor logtool_colorWithHexString:@"#999999"]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[[UIImage imageNamed:image]logtool_imageWithTintColor:LogTool_Color_Tin_COLOR]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    LogToolNavViewController *nav =  [[LogToolNavViewController alloc]initWithRootViewController:vc];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    attrs[NSForegroundColorAttributeName] = [UIColor logtool_colorWithHexString:@"#999999"];
    
    NSMutableDictionary *attrs1 = [NSMutableDictionary dictionary];
    attrs1[NSFontAttributeName] = attrs[NSFontAttributeName];
    attrs1[NSForegroundColorAttributeName] = LogTool_Color_Tin_COLOR;
    [vc.tabBarItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:attrs1 forState:UIControlStateSelected];
    
    vc.hidesBottomBarWhenPushed = NO;
    [self addChildViewController:nav];
}



@end
