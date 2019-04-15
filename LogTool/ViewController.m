//
//  ViewController.m
//  LogTool
//
//  Created by DingYD on 2019/3/29.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import "ViewController.h"
#import "LogStatisticalTabBarViewController.h"
#import "LogToolTabBarViewController.h"
#import "LogTool/LogToolHeader.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (IBAction)newBtnAction:(id)sender {
    
    
    
    [self presentViewController:[LogToolTabBarViewController new] animated:YES completion:nil];
}
- (IBAction)oldBtnAction:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LogStatistical" bundle:nil];
    LogStatisticalTabBarViewController *tabbarVC = [sb instantiateViewControllerWithIdentifier:@"LogStatisticalTabBarViewControllerID"];
    [self presentViewController:tabbarVC animated:YES completion:nil];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self performSelector:@selector(selector) withObject:self];
}



@end
