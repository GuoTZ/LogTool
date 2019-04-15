//
//  LogToolPrintMsgModel.h
//  LogTool
//
//  Created by DingYD on 2019/3/29.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LogToolMessageModel;
@interface LogToolPrintMsgModel : NSObject
/**
 打印字符串
 =
 @param file 文件
 @param line 行数
 @param menthod 方法
 @param formatStr 打印的字符串
 @return 返回字符串
 */
+ (LogToolMessageModel *)printStrWithfile:(const char *) file Andline:(int) line menthod:(const char *) menthod formatStr:(const char *) formatStr;

+ (void)printHttp:(LogToolMessageModel *)msg;

+ (void)printInfo:(LogToolMessageModel *)msg;

+ (void)printOther:(LogToolMessageModel *)msg;

+ (void)printWarning:(LogToolMessageModel *)msg;

+ (void)printError:(LogToolMessageModel *)msg;

@end

NS_ASSUME_NONNULL_END
