//
//  LogToolExceptionHandler.m
//  LogTool
//
//  Created by DingYD on 2019/3/30.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import "LogToolExceptionHandler.h"
#import "LogToolPrintMsgModel.h"
@implementation LogToolExceptionHandler

+(void)catchCrashLogs{
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}
void UncaughtExceptionHandler(NSException *exception){
    if (exception ==nil)return;
    NSArray *array = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name  = [exception name];
    NSDictionary *error  = [exception userInfo]==nil ? @{} : [exception userInfo];
    NSDictionary *dict = @{@"App异常":@{@"崩溃异常的名称":name,@"崩溃异常的原因":reason,@"崩溃异常的信息":error,@"出现崩溃异常的堆栈":array}};
    NSString *jsonStrin = @"";
    @try {
        NSError *error = nil;
        //字典转成json
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted  error:&error];
        //如果报错了就按原先的格式输出
        
        jsonStrin = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } @catch (NSException *exception) {
        
    }
    const char *file = [name UTF8String];
    const char *menthod = [reason UTF8String];
    [LogToolPrintMsgModel printError:[LogToolPrintMsgModel printStrWithfile:file Andline:0 menthod:menthod formatStr:[jsonStrin UTF8String]]];
}

@end
