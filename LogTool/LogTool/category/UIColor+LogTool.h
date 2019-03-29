//
//  UIColor+LogTool.h
//  LogTool
//
//  Created by DingYD on 2019/3/29.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (LogTool)
+ (UIColor *)logtool_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

//默认alpha值为1
+ (UIColor *)logtool_colorWithHexString:(NSString *)color;
@end

NS_ASSUME_NONNULL_END
