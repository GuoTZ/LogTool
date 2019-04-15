//
//  LogToolStatistical.m
//  LogTool
//
//  Created by DingYD on 2019/3/30.
//  Copyright © 2019 DingYD. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LogToolTabBarViewController.h"
#import "LogToolStatistical.h"
#import "LogToolHeader.h"
@interface LogToolStatistical()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIButton *button;

@end
@implementation LogToolStatistical
static LogToolStatistical* _instance = nil;

+(instancetype) shareInstance {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[LogToolStatistical alloc] init];
        [_instance performSelector:@selector(createButton) withObject:nil afterDelay:0];
    }) ;
    
    return _instance ;
}

/**
 显示按钮
 */
- (void)showButton {
    self.button.hidden = NO;
}

/**
 隐藏按钮
 */
- (void)hiddenButton {
    self.button.hidden = YES;
}



#pragma mark - 创建悬浮的按钮
- (void)createButton{
    _window = [UIApplication sharedApplication].keyWindow;
    _window.windowLevel = UIWindowLevelAlert;
    
    if (_window == nil) {
        NSLog(@"请先再AppDelegate设置keyWindow");
    }
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setTitle:@"按钮" forState:UIControlStateNormal];
    _button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, [UIScreen mainScreen].bounds.size.height - 150, 45, 45);
    _button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_button setBackgroundColor:LogTool_Color_Tin_COLOR];
    _button.layer.cornerRadius = 22.5;
    _button.layer.masksToBounds = YES;
    _button.layer.borderWidth = 6;
    _button.layer.borderColor = LogTool_Color_Label_TITLECOLOR.CGColor;
    [_button addTarget:self action:@selector(resignButton) forControlEvents:UIControlEventTouchUpInside];
    [_window addSubview:_button];
    //放一个拖动手势，用来改变控件的位置
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changePostion:)];
    [_button addGestureRecognizer:pan];
}

- (void)resignButton{
    LogToolTabBarViewController *tabbarVC = [[LogToolTabBarViewController alloc]init];
    [self.currentViewController presentViewController:tabbarVC animated:YES completion:nil];
}

//手势事件 －－ 改变位置

-(void)changePostion:(UIPanGestureRecognizer *)pan{
    
    CGPoint point = [pan translationInView:_button];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGRect originalFrame = _button.frame;
    if (originalFrame.origin.x >= 0 && originalFrame.origin.x+originalFrame.size.width <= width) {
        originalFrame.origin.x += point.x;
    }if (originalFrame.origin.y >= 0 && originalFrame.origin.y+originalFrame.size.height <= height) {
        originalFrame.origin.y += point.y;
    }
    
    _button.frame = originalFrame;
    [pan setTranslation:CGPointZero inView:_button];
    if (pan.state == UIGestureRecognizerStateBegan) {
        _button.enabled = NO;
    }else if (pan.state == UIGestureRecognizerStateChanged){
    } else {
        CGRect frame = _button.frame;
        //是否越界
        BOOL isOver = NO;
        if (frame.origin.x < 0) {
            
            frame.origin.x = 0;
            isOver = YES;
        } else if (frame.origin.x+frame.size.width > width) {
            frame.origin.x = width - frame.size.width;
            isOver = YES;
        }if (frame.origin.y < 0) {
            frame.origin.y = 0;
            isOver = YES;
        } else if (frame.origin.y+frame.size.height > height) {
            frame.origin.y = height - frame.size.height;
            isOver = YES;
        }if (isOver) {
            __weak __typeof(self) weakSelf  = self;
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.button.frame = frame;
            }];
        }
        _button.enabled = YES;
    }
}
//获取Window当前显示的ViewController
- (UIViewController*)currentViewController {
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}
@end
