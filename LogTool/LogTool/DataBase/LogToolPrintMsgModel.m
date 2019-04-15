//
//  LogToolPrintMsgModel.m
//  LogTool
//
//  Created by DingYD on 2019/3/29.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import "LogToolPrintMsgModel.h"
#import "LogToolSQLiteManager.h"
#import "LogToolMessageModel.h"
#import "NSDate+LogTool.h"
@implementation LogToolPrintMsgModel

/**
 打印字符串
 =
 @param file 文件
 @param line 行数
 @param menthod 方法
 @param formatStr 打印的字符串
 @return 返回字符串
 */
+ (LogToolMessageModel *)printStrWithfile:(const char *) file Andline:(int) line menthod:(const char *) menthod formatStr:(const char *) formatStr{
    const char *date = [[NSDate currenttDate_logtool] UTF8String];
    printf("———————————————Start printing———————————————");
    printf("\ndate:\n\t%s\nclass:\n\tfile:%s\n\tline:%d\nmenthod: \n\t%s\ncontent:\n\t%s",date, file, line, menthod, formatStr);
    printf("\n———————————————Stop printing———————————————\n");
    printf("\n");
    LogToolMessageModel *model = [[LogToolMessageModel alloc]init];
    model.fileStr = [NSString stringWithUTF8String:file];
    model.menthodStr= [NSString stringWithUTF8String:menthod];
    model.formatStrStr = [NSString stringWithUTF8String:formatStr];
    model.line = line;
    return model;
    
}

/**
 0 HTTP 1 Info 2Other 3Warning 4Error

 @param msg msg description
 */
+ (void)printHttp:(LogToolMessageModel *)msg{
    msg.type = 0;
    [[LogToolSQLiteManager shareInstance] insert:msg];
}

+ (void)printInfo:(LogToolMessageModel *)msg{
    msg.type = 1;
    [[LogToolSQLiteManager shareInstance] insert:msg];
}

+ (void)printOther:(LogToolMessageModel *)msg{
    msg.type = 2;
    [[LogToolSQLiteManager shareInstance] insert:msg];
}

+ (void)printWarning:(LogToolMessageModel *)msg{
    msg.type = 3;
    [[LogToolSQLiteManager shareInstance] insert:msg];
}

+ (void)printError:(LogToolMessageModel *)msg{
    msg.type = 4;
    [[LogToolSQLiteManager shareInstance] insert:msg];
}

@end
