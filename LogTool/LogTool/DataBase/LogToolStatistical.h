//
//  LogToolStatistical.h
//  LogTool
//
//  Created by DingYD on 2019/3/30.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogToolStatistical : NSObject
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

NS_ASSUME_NONNULL_END
