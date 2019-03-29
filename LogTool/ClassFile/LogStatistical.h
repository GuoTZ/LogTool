//
//  LogStatistical.h
//  LogStatistical
//
//  Created by RM on 2018/6/23.
//  Copyright © 2018年 GTZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogStatistical : NSObject
/**
 单例
 */
+(instancetype) shareInstance;

/**
 显示按钮
 */
- (void)showButton;

/**
 隐藏按钮
 */
- (void)hiddenButton;


@end
